defmodule Result do
  def ok(v) do
    {:ok, v}
  end

  def error(v) do
    {:error, v}
  end
end
