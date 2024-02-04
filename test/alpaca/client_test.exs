defmodule Alpaca.ClientTest do
  use ExUnit.Case

  @mock_response %{
    "symbol" => "SPY",
    "trade" => %{
      "c" => [" "],
      "i" => 58_520_343_100_232,
      "p" => 490.50,
      "s" => 100,
      "t" => "2024-02-02T20:59:58.604342528Z",
      "x" => "V",
      "z" => "B"
    }
  }

  setup do
    Tesla.Mock.mock(fn
      %{method: :get} ->
        %Tesla.Env{status: 200, body: @mock_response}
    end)

    :ok
  end

  test "here" do
    {:ok, price, _date} = Alpaca.Client.latest_price("SPY")
    assert price == 490.50
  end
end
