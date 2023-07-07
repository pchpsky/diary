defmodule DiaryWeb.Schema.ContextHelpers do
  def current_user(%{context: %{current_user: user}}), do: user
end
