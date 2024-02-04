defmodule Alpaca.Client do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://data.alpaca.markets/v2"
  plug Tesla.Middleware.Headers, [{"APCA-API-KEY-ID", get_key()}]

  plug Tesla.Middleware.Headers, [
    {"APCA-API-SECRET-KEY", get_secret()}
  ]

  plug Tesla.Middleware.JSON

  defp get_key do
    case System.get_env("ALPACA_KEY") do
      nil -> raise "ALPACA_KEY environment variable not found"
      value -> value
    end
  end

  defp get_secret do
    case System.get_env("ALPACA_SECRET") do
      nil -> raise "ALPACA_SECRET environment variable not found"
      value -> value
    end
  end

  def latest_price(symbol) do
    {:ok, response} = get("/stocks/#{symbol}/trades/latest?feed=iex")

    trade =
      response
      |> Map.get(:body)
      |> Map.get("trade")

    price =
      trade
      |> Map.get("p")

    {:ok, date, _} =
      trade
      |> Map.get("t")
      |> DateTime.from_iso8601()

    {:ok, price, date}
  end
end
