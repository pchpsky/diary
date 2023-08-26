defmodule DiaryWeb.Api.SessionJSON do
  def show(%{token: token}), do: %{token: token}
end
