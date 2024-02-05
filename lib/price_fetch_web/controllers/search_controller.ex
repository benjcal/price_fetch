defmodule PriceFetchWeb.SearchController do
  use PriceFetchWeb, :controller

  def redir(conn, _params) do
    redirect(conn, to: ~p"/search")
  end

  def index(conn, _params) do
    render(conn, :index)
  end

  def create(conn, %{"symbol" => symbol}) do
    redirect(conn, to: "/search/#{symbol}")
  end

  def show(conn, %{"symbol" => symbol}) do
    case PriceFetch.get_symbol_snapshot(symbol) do
      {:ok, data} -> render(conn, :show, data: data)
      {:error, _} -> render(conn, :error, symbol: symbol)
    end
  end
end
