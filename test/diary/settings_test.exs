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
    setup do
      user = user_fixture()

      %{settings: settings_fixture(user.id)}
    end

    test "returns all insulins", %{settings: settings} do
      insulin = insulin_fixture(settings.id)

      assert [^insulin] = Settings.list_insulins(settings.id)
    end
  end

  describe "get_insulin!/1" do
    setup do
      user = user_fixture()

      %{settings: settings_fixture(user.id)}
    end

    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Settings.get_insulin!(-1)
      end
    end

    test "returns the user with the given id", %{settings: settings} do
      %{id: id} = insulin = insulin_fixture(settings.id)
      assert %Insulin{id: ^id} = Settings.get_insulin!(insulin.id)
    end
  end

  describe "create_insulin/2" do
    setup do
      user = user_fixture()

      %{settings: settings_fixture(user.id)}
    end

    test "requires name", %{settings: settings} do
      {:error, changeset} = Settings.create_insulin(settings.id, %{})

      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "with valid params creates insulin", %{settings: settings} do
      name = "insulin"
      color = "green"
      settings_id = settings.id

      {:ok, insulin} =
        Settings.create_insulin(
          settings.id,
          %{
            name: name,
            color: color
          }
        )

      assert %{name: ^name, color: ^color, settings_id: ^settings_id} = insulin
    end
  end

  describe "create_insulins/2" do
    setup do
      user = user_fixture()

      %{settings: settings_fixture(user.id)}
    end

    test "requires name", %{settings: settings} do
      name = "insulin"
      color = "green"
      settings_id = settings.id

      assert {:error, {1, changeset}} =
               Settings.create_insulins(settings_id, [
                 %{
                   name: name,
                   color: color,
                   default_dose: 10
                 },
                 %{}
               ])

      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "with valid params creates insulins", %{settings: settings} do
      name = "insulin"
      color = "green"
      settings_id = settings.id

      assert {:ok, insulins} =
               Settings.create_insulins(
                 settings.id,
                 [
                   %{
                     name: name <> "1",
                     color: color,
                     default_dose: 10
                   },
                   %{
                     name: name <> "2",
                     color: color
                   }
                 ]
               )

      assert [
               %{name: "insulin1", color: ^color, settings_id: ^settings_id},
               %{name: "insulin2", color: ^color, settings_id: ^settings_id}
             ] = insulins
    end
  end
end
