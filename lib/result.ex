defmodule Result do
  @moduledoc false

  def ok(v) do
    {:ok, v}
  end

  def error(v) do
    {:error, v}
  end

  def bimap(result, left_cb, right_cb) do
    case result do
      {:ok, v} -> ok(right_cb.(v))
      {:error, v} -> error(left_cb.(v))
    end
  end

  def map(result, cb), do: bimap(result, & &1, cb)

  def map_error(result, cb), do: bimap(result, cb, & &1)
end
