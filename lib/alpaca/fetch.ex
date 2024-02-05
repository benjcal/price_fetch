defmodule Alpaca.Fetch do
  use Tesla

  plug Tesla.Middleware.BaseUrl, get_api_url()
  plug Tesla.Middleware.Headers, get_api_key_header()
  plug Tesla.Middleware.Headers, get_api_secret_header()
  plug Tesla.Middleware.JSON

  def snapshot(symbol) do
    case get!("/stocks/#{symbol}/snapshot?feed=iex") do
      %{status: 200, body: body} ->
        if valid_body?(body) do
          {:ok, body}
        else
          {:error, :invalid_response}
        end

      %{status: status, body: body} ->
        dbg("Alpaca responded with status #{status} and body #{Jason.encode!(body)}")
        {:error, status}
    end
  end

  def valid_body?(%{
        "symbol" => _,
        "prevDailyBar" => %{"c" => _},
        "latestTrade" => %{"p" => _, "t" => _}
      }) do
    true
  end

  def valid_body?(_) do
    false
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

  defp get_api_key_header do
    [{"APCA-API-KEY-ID", get_api_key()}]
  end

  defp get_api_secret_header do
    [
      {"APCA-API-SECRET-KEY", get_api_secret()}
    ]
  end

  def _sample_snapshot_body do
    %{
      "dailyBar" => %{
        "c" => 494.29,
        "h" => 496.04,
        "l" => 489.34,
        "n" => 11839,
        "o" => 489.66,
        "t" => "2024-02-02T05:00:00Z",
        "v" => 1_262_797,
        "vw" => 493.166808
      },
      "latestQuote" => %{
        "ap" => 494.54,
        "as" => 10,
        "ax" => "V",
        "bp" => 493.05,
        "bs" => 10,
        "bx" => "V",
        "c" => ["R"],
        "t" => "2024-02-05T13:04:34.700512256Z",
        "z" => "B"
      },
      "latestTrade" => %{
        "c" => [" "],
        "i" => 58_520_343_100_232,
        "p" => 494.29,
        "s" => 100,
        "t" => "2024-02-02T20:59:58.604342528Z",
        "x" => "V",
        "z" => "B"
      },
      "minuteBar" => %{
        "c" => 494.29,
        "h" => 494.63,
        "l" => 494.29,
        "n" => 230,
        "o" => 494.63,
        "t" => "2024-02-02T20:59:00Z",
        "v" => 30360,
        "vw" => 494.41776
      },
      "prevDailyBar" => %{
        "c" => 489.22,
        "h" => 489.22,
        "l" => 483.8,
        "n" => 12715,
        "o" => 484.73,
        "t" => "2024-02-01T05:00:00Z",
        "v" => 1_636_158,
        "vw" => 487.193658
      },
      "symbol" => "SPY"
    }
  end
end
