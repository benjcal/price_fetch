defmodule Alpaca.FetchTest do
  use ExUnit.Case
  alias Alpaca.Fetch

  test "valid response body" do
    assert Fetch.valid_body?(Fetch._sample_snapshot_body())
  end

  test "invalid response body" do
    assert Fetch.valid_body?(%{}) == false
  end
end
