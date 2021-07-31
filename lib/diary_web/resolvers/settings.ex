defmodule DiaryWeb.Resolvers.Settings do
  @moduledoc false
  alias Diary.Settings

  def list_insulins(_parent, _args, %{context: %{current_user: _user}}) do
    Settings.list_insulins() |> Result.ok()
  end
end
