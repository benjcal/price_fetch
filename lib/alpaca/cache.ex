defmodule Alpaca.Cache do
  @cache_name :alpaca_cache
  @cache_expiry 900

  def put!(key, val) do
    Cachex.put!(@cache_name, key, val)
    Cachex.expire!(@cache_name, key, :timer.seconds(@cache_expiry))
    # Cachex.expire!(@cache_name, key, :timer.seconds(30))
  end

  def get!(key) do
    Cachex.get!(@cache_name, key)
  end

  def exists?(key) do
    {:ok, exists} = Cachex.exists?(@cache_name, key)
    exists
  end

  def keys do
    Cachex.keys!(@cache_name) |> Enum.sort()
  end
end
