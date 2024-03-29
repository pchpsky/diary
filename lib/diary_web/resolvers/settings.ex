defmodule DiaryWeb.Resolvers.Settings do
  @moduledoc false
  alias Diary.Settings
  import DiaryWeb.Schema.ChangesetHelpers

  def get_settings(_parent, _args, %{context: %{current_user: user}}) do
    user.id
    |> Settings.get_settings()
    |> Result.ok()
  end

  def update_settings(_parent, %{input: args}, %{context: %{current_user: user}}) do
    user.id
    |> Settings.get_settings()
    |> Settings.update_settings(args)
    |> Result.Error.map(&render_invalid_changeset/1)
  end

  def list_insulins(settings, _args, %{context: %{current_user: _user}}) do
    settings.id
    |> Settings.list_insulins()
    |> Result.ok()
  end

  def create_insulin(_, %{input: args}, %{context: %{current_user: user}}) do
    settings =
      user.id
      |> Settings.get_settings()

    settings.id
    |> Settings.create_insulin(args)
    |> Result.Error.map(&render_invalid_changeset/1)
  end

  def create_insulins(_, %{input: args}, %{context: %{current_user: user}}) do
    settings =
      user.id
      |> Settings.get_settings()

    settings.id
    |> Settings.create_insulins(args)
    |> Result.Error.map(fn {pos, changeset} -> render_invalid_changeset(changeset, "Invalid insulin at #{pos}") end)
  end

  def update_insulin(_, %{id: id, input: args}, %{context: %{current_user: _user}}) do
    id
    |> Settings.get_insulin()
    |> Result.cond(& &1, %{message: "Insulin not found.", code: 404})
    |> Result.and_then(fn insulin ->
      insulin
      |> Settings.update_insulin(args)
      |> Result.Error.map(&render_invalid_changeset/1)
    end)
  end

  def delete_insulin(_, %{id: id}, %{context: %{current_user: _user}}) do
    id
    |> Settings.get_insulin()
    |> Result.cond(& &1, %{message: "Insulin not found.", code: 404})
    |> Result.and_then(fn insulin ->
      insulin
      |> Settings.delete_insulin()
      |> Result.Error.map(&render_invalid_changeset/1)
    end)
  end
end
