defmodule Result do
  @moduledoc false

  def ok(v) do
    {:ok, v}
  end

  def error(v) do
    {:error, v}
  end

  def bimap({:ok, v}, _, right_cb), do: ok(right_cb.(v))
  def bimap({:error, v}, left_cb, _), do: error(left_cb.(v))

  def map(result, cb), do: bimap(result, & &1, cb)

  def map_error(result, cb), do: bimap(result, cb, & &1)
end
