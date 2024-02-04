defmodule Alpaca.Cache do
  @cache_name :alpaca_cache

  def put!(key, val) do
    Cachex.put!(@cache_name, key, val)
    # Cachex.expire!(@cache_name, key, :timer.seconds(900)) # set expiry to 15 min
    Cachex.expire!(@cache_name, key, :timer.seconds(10))
  end

  def get!(key) do
    Cachex.get!(@cache_name, key)
  end

  def exists?(key) do
    {:ok, exists} = Cachex.exists?(@cache_name, key)
    exists
  end
end
