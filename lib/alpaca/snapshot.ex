defmodule Alpaca.Snapshot do
  alias Alpaca.Snapshot

  defstruct symbol: "", price: 0.0, time: 0, prev_day_price: 0.0

  def from_map(%{
        "symbol" => symbol,
        "prevDailyBar" => %{"c" => prev_day_price},
        "latestTrade" => %{"p" => price, "t" => time}
      }) do
    %Snapshot{
      symbol: symbol,
      price: price,
      prev_day_price: prev_day_price,
      time: time
    }
  end

  def from_map(_) do
    :error
  end

  def get_diff_number(%Snapshot{price: p, prev_day_price: pdp}) do
    p - pdp
  end

  def get_diff_percent(%Snapshot{price: p, prev_day_price: pdp}) do
    (p - pdp) / p * 100
  end

  def get_diff_sign(%Snapshot{price: p, prev_day_price: pdp}) do
    diff = p - pdp

    cond do
      diff == 0 -> :neutral
      diff > 0 -> :positive
      diff < 0 -> :negative
    end
  end

  def get_price_str(%Snapshot{price: p}) do
    p
    |> Number.Currency.number_to_currency()
  end

  def get_market_time_str(%Snapshot{time: t}) do
    {:ok, time, _} =
      t
      |> DateTime.from_iso8601()

    time
    |> DateTime.shift_zone!("America/New_York")
    |> Calendar.strftime("%B %-d %-I:%M%p")
  end

  def get_diff_number_str(%Snapshot{price: p, prev_day_price: pdp}) do
    (p - pdp)
    |> Number.Delimit.number_to_delimited()
  end

  def get_diff_percent_str(%Snapshot{price: p, prev_day_price: pdp}) do
    ((p - pdp) / p * 100)
    |> Number.Percentage.number_to_percentage(precision: 2)
  end
end
