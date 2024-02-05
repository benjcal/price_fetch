defmodule PriceFetch do
  @moduledoc """
  PriceFetch keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Alpaca.Snapshot
  alias Alpaca.Fetch
  alias Alpaca.Cache

  def get_symbol_snapshot(symbol) do
    cond do
      Cache.exists?(symbol) ->
        {:ok, Cache.get!(symbol)}

      true ->
        case Fetch.snapshot(symbol) do
          {:ok, snapshot} ->
            data = Snapshot.from_map(snapshot)
            Cache.put!(symbol, data)
            {:ok, data}

          e ->
            e
        end
    end
  end
end
