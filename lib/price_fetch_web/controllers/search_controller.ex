defmodule PriceFetchWeb.SearchController do
  use PriceFetchWeb, :controller
  alias Alpaca.Snapshot

  import Plug.Conn,
    only: [assign: 3]

  def redir(conn, _params) do
    redirect(conn, to: ~p"/search")
  end

  def index(conn, _params) do
    conn
    |> assign(:recent, Alpaca.Cache.keys())
    |> render(:index)
  end

  def create(conn, %{"symbol" => symbol}) do
    redirect(conn, to: "/search/#{symbol}")
  end

  def show(conn, %{"symbol" => symbol}) do
    case PriceFetch.get_symbol_snapshot(symbol) do
      {:ok, data} ->
        data =
          data
          |> prepare_data

        conn
        |> assign(:data, data)
        |> assign(:recent, Alpaca.Cache.keys())
        |> render(:show)

      {:error, _} ->
        render(conn, :error, symbol: symbol)
    end
  end

  defp prepare_data(data) do
    %{
      symbol: data.symbol,
      price: Snapshot.get_price_str(data),
      time: Snapshot.get_market_time_str(data),
      diff_number: Snapshot.get_diff_number_str(data),
      diff_percent: Snapshot.get_diff_percent_str(data),
      diff_sign: Snapshot.get_diff_sign(data)
    }
  end
end
