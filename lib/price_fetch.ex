defmodule PriceFetch do
  @moduledoc """
  PriceFetch keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Alpaca.Fetch
  alias Alpaca.Cache

  def get_symbol_snapshot(symbol) do
    cond do
      Cache.exists?(symbol) ->
        IO.puts("Cache hit")

        {:ok, Cache.get!(symbol)}

      true ->
        IO.puts("API call")

        case Fetch.snapshot(symbol) do
          {:ok, snapshot} ->
            Cache.put!(symbol, snapshot)
            {:ok, snapshot}

          e ->
            e
        end
    end
  end
end
