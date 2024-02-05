defmodule Alpaca.Fetch do
  use Tesla

  plug Tesla.Middleware.BaseUrl, get_api_url()
  plug Tesla.Middleware.Headers, [{"APCA-API-KEY-ID", get_api_key()}]

  plug Tesla.Middleware.Headers, [
    {"APCA-API-SECRET-KEY", get_api_secret()}
  ]

  plug Tesla.Middleware.JSON

  def snapshot(symbol) do
    case get!("/stocks/#{symbol}/snapshot?feed=iex") do
      %{status: 200, body: body} ->
        process_success(body)

      %{status: status, body: body} ->
        process_error(status, body)
    end
  end

  defp process_success(body) do
    symbol = get_symbol(body)
    price = get_price(body)
    diff_number = get_diff_number(body)
    diff_percent = get_diff_percent(body)
    diff_sign = get_diff_sign(body)
    datetime = get_datetime(body)

    {:ok,
     %{
       symbol: symbol,
       price: price,
       diff_number: diff_number,
       diff_percent: diff_percent,
       diff_sign: diff_sign,
       datetime: datetime
     }}
  end

  defp get_price_number(body) do
    body
    |> Map.get("latestTrade")
    |> Map.get("p")
  end

  defp get_prev_price_number(body) do
    body
    |> Map.get("prevDailyBar")
    |> Map.get("c")
  end

  defp get_price(body) do
    get_price_number(body)
    |> Number.Currency.number_to_currency()
  end

  defp get_datetime(body) do
    {:ok, datetime, _} =
      body
      |> Map.get("latestTrade")
      |> Map.get("t")
      |> DateTime.from_iso8601()

    datetime
  end

  defp get_symbol(body) do
    body
    |> Map.get("symbol")
  end

  defp get_diff_number(body) do
    p = get_price_number(body)
    pp = get_prev_price_number(body)

    (p - pp)
    |> Number.Delimit.number_to_delimited()
  end

  defp get_diff_percent(body) do
    p = get_price_number(body)
    pp = get_prev_price_number(body)

    ((p - pp) / p * 100)
    |> Number.Percentage.number_to_percentage(precision: 2)
  end

  defp get_diff_sign(body) do
    p = get_price_number(body)
    pp = get_prev_price_number(body)

    diff = p - pp

    cond do
      diff == 0 -> :neutral
      diff > 0 -> :positive
      diff < 0 -> :negative
    end
  end

  defp process_error(status, body) do
    {:error, "Alpaca responded with status #{status} and body #{Jason.encode!(body)}"}
  end

  defp get_api_url do
    System.get_env("PRICE_FETCH_ALPACA_URL")
  end

  defp get_api_key do
    System.get_env("PRICE_FETCH_ALPACA_KEY")
  end

  defp get_api_secret do
    System.get_env("PRICE_FETCH_ALPACA_SECRET")
  end
end
