defmodule Diary.SettingsTest do
  use Diary.DataCase

  alias Diary.Settings
  alias Diary.Settings.Insulin
  import Diary.SettingsFixtures
  import Diary.AccountsFixtures

  describe "get_settings/1" do
    setup do
      %{user: user_fixture()}
    end

    test "returns user settings", %{user: user} do
      settings_fixture(user.id, %{blood_glucose_units: :mg_per_dl})

      settings = Settings.get_settings(user.id)

      assert %{blood_glucose_units: :mg_per_dl} = settings
    end

    test "creates and returns settings if user doesn't have any", %{user: user} do
      settings = Settings.get_settings(user.id)

      assert %{blood_glucose_units: :mmol_per_l} = settings
    end
  end

  describe "list_insulins/0" do
    test "returns all insulins" do
      insulin = insulin_fixture()

      assert [^insulin] = Settings.list_insulins()
    end
  end

  describe "get_insulin!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Settings.get_insulin!(-1)
      end
    end

    test "returns the user with the given id" do
      %{id: id} = insulin = insulin_fixture()
      assert %Insulin{id: ^id} = Settings.get_insulin!(insulin.id)
    end
  end

  describe "create_insulin/1" do
    test "requires name" do
      {:error, changeset} = Settings.create_insulin(%{})

      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "with valid params creates insulin" do
      name = "insulin"
      color = "green"
      {:ok, insulin} = Settings.create_insulin(%{name: name, color: color})

      assert %{name: ^name, color: ^color} = insulin
    end
  end
end
