defmodule PriceFetchWeb.SearchController do
  use PriceFetchWeb, :controller

  def redir(conn, _params) do
    redirect(conn, to: ~p"/search")
  end

  def index(conn, _params) do
    render(conn, :index)
  end

  def create(conn, %{"symbol" => symbol}) do
    redirect(conn, to: ~p"/search/#{symbol}")
  end

  def show(conn, %{"symbol" => symbol}) do
    {:ok, price} = Alpaca.get_symbol_price(symbol)

    render(conn, :show, symbol: symbol, price: Map.get(price, :price))
  end
end
