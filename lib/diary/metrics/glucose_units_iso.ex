defmodule Diary.Metrics.GlucoseUnitsIso do
  def to_default(value, :mmol_per_l), do: value * 18.0

  def to_default(value, :mg_per_dl), do: value

  def from_default(value, :mmol_per_l), do: value / 18.0

  def from_default(value, :mg_per_dl), do: value
end
