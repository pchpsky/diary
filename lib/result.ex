defmodule Result do
  @moduledoc false

  def ok(v) do
    {:ok, v}
  end

  def error(v) do
    {:error, v}
  end

  def map_error({:ok, _} = result, _), do: result

  def map_error({:error, error}, cb) when is_function(cb, 1) do
    {:error, cb.(error)}
  end
end
