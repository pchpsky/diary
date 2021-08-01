defmodule Diary.SettingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Diary.Settings` context.
  """

  alias Diary.Settings.UserSettings

  def settings_fixture(user_id, attrs \\ %{}) do
    {:ok, settings} =
      %UserSettings{user_id: user_id}
      |> UserSettings.changeset(attrs)
      |> Diary.Repo.insert()

    settings
  end

  def insulin_fixture(attrs \\ %{}) do
    {:ok, insulin} =
      attrs
      |> Enum.into(%{name: "insulin", color: "#e8d16e"})
      |> Diary.Settings.create_insulin()

    insulin
  end
end
