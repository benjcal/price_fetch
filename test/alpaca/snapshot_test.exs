defmodule Alpaca.SnapshotTest do
  use ExUnit.Case
  alias Alpaca.Snapshot

  @map Alpaca.Fetch._sample_snapshot_body()

  test "create %Snapshot{} from valid map" do
    s = Snapshot.from_map(@map)

    assert s.symbol == "SPY"
    assert s.price == 494.29
    assert s.prev_day_price == 489.22
    assert s.time == "2024-02-02T20:59:58.604342528Z"
  end

  test "create %Snapshot{} from invalid" do
    s = Snapshot.from_map(%{})

    assert s == :error
  end

  test "get_diff_number" do
    d =
      Snapshot.from_map(@map)
      |> Snapshot.get_diff_number()
      |> Number.Delimit.number_to_delimited()

    assert d == "5.07"
  end

  test "get_diff_percent" do
    p =
      Snapshot.from_map(@map)
      |> Snapshot.get_diff_percent()
      |> Number.Delimit.number_to_delimited()

    assert p == "1.03"
  end

  test "get_diff_sign" do
    s =
      Snapshot.from_map(@map)
      |> Snapshot.get_diff_sign()

    assert s == :positive
  end

  test "get_price_str" do
    p =
      Snapshot.from_map(@map)
      |> Snapshot.get_price_str()

    assert p == "$494.29"
  end

  test "get_market_time_str" do
    t =
      Snapshot.from_map(@map)
      |> Snapshot.get_market_time_str()

    assert t == "February 2 3:59PM"
  end

  test "get_diff_number_str" do
    d =
      Snapshot.from_map(@map)
      |> Snapshot.get_diff_number_str()

    assert d == "5.07"
  end

  test "get_diff_percent_str" do
    p =
      Snapshot.from_map(@map)
      |> Snapshot.get_diff_percent_str()

    assert p == "1.03%"
  end
end
