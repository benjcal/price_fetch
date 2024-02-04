defmodule Alpaca do
  alias Alpaca.Fetch
  alias Alpaca.Cache

  def get_symbol_price(symbol) do
    cond do
      Cache.exists?(symbol) ->
        IO.puts("Cache hit")

        {:ok, Cache.get!(symbol)}

      true ->
        IO.puts("API call")

        case Fetch.latest_price(symbol) do
          {:ok, price} ->
            Cache.put!(symbol, price)
            {:ok, price}

          e ->
            e
        end
    end
  end
end
