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
    {:ok, data} = PriceFetch.get_symbol_snapshot(symbol)

    render(conn, :show, data: data)
  end
end
