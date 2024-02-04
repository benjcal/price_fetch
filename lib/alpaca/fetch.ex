defmodule Alpaca.Fetch do
  use Tesla

  plug Tesla.Middleware.BaseUrl, get_api_url()
  plug Tesla.Middleware.Headers, [{"APCA-API-KEY-ID", get_api_key()}]

  plug Tesla.Middleware.Headers, [
    {"APCA-API-SECRET-KEY", get_api_secret()}
  ]

  plug Tesla.Middleware.JSON

  def latest_price(symbol) do
    case get!("/stocks/#{symbol}/bars/latest?feed=iex") do
      %{status: 200, body: body} ->
        process_success(body)

      %{status: status, body: body} ->
        process_error(status, body)
    end
  end

  defp process_success(body) do
    bar = Map.get(body, "bar")

    price =
      bar
      |> Map.get("c")

    {:ok, date, _} =
      bar
      |> Map.get("t")
      |> DateTime.from_iso8601()

    {:ok, %{price: price, date: date}}
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
