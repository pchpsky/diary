defmodule DiaryWeb.Resolvers.Settings do
  @moduledoc false
  alias Diary.Settings

  def get_settings(_parent, _args, %{context: %{current_user: user}}) do
    user.id
    |> Settings.get_settings()
    |> Result.ok()
  end

  def list_insulins(settings, _args, %{context: %{current_user: _user}}) do
    settings.id
    |> Settings.list_insulins()
    |> Result.ok()
  end
end
