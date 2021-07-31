defmodule Diary.SettingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Diary.Settings` context.
  """

  def insulin_fixture(attrs \\ %{}) do
    {:ok, insulin} =
      attrs
      |> Enum.into(%{name: "insulin", color: "#e8d16e"})
      |> Diary.Settings.create_insulin()

    insulin
  end
end
