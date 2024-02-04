defmodule Alpaca.FetchTest do
  use ExUnit.Case

  @mock_response %{
    "bar" => %{
      "c" => 494.29,
      "h" => 494.63,
      "l" => 494.29,
      "n" => 230,
      "o" => 494.63,
      "t" => "2024-02-02T20:59:00Z",
      "v" => 30360,
      "vw" => 494.41776
    },
    "symbol" => "SPY"
  }

  setup do
    Tesla.Mock.mock(fn
      %{method: :get} ->
        %Tesla.Env{status: 200, body: @mock_response}
    end)

    :ok
  end

  test "correct response" do
    {:ok, price, _date} = Alpaca.Fetch.latest_price("SPY")
    assert price == 494.29
  end
end
