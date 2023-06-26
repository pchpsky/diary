defmodule Diary.SettingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Diary.Settings` context.
  """

  alias Diary.Settings.{UserSettings, Insulin}

  def settings_fixture(user_id, attrs \\ %{}) do
    {:ok, settings} =
      %UserSettings{user_id: user_id}
      |> UserSettings.changeset(attrs)
      |> Diary.Repo.insert()

    settings
  end

  def insulin_fixture(settings_id, attrs \\ %{}) do
    {:ok, insulin} =
      %Insulin{name: "insulin", color: "#e8d16e", default_dose: 10, settings_id: settings_id}
      |> Insulin.changeset(attrs)
      |> Diary.Repo.insert()

    insulin
  end
end
