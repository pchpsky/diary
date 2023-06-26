defmodule DiaryWeb.Schema.SettingsTest do
  use DiaryWeb.ConnCase

  import Diary.AccountsFixtures
  import Diary.ApiHelpers
  import Diary.SettingsFixtures

  describe "query settings" do
    @describetag :graphql

    @settings_query """
    {
      settings {
        bloodGlucoseUnits
        insulins {
          id
          name
          color
          defaultDose
        }
      }
    }
    """

    setup %{conn: conn} do
      user = user_fixture()
      conn = sign_in(conn, user)
      %{user: user, conn: conn}
    end

    test "returns user settings", %{conn: conn, user: user} do
      settings = settings_fixture(user.id, %{blood_glucose_units: :mg_per_dl})
      %{id: insulin_id} = insulin_fixture(settings.id)
      insulin_id = to_string(insulin_id)
      conn = post(conn, "/graph", %{"query" => @settings_query})

      response = json_response(conn, 200)

      assert(
        %{
          "data" => %{
            "settings" => %{
              "bloodGlucoseUnits" => "MG_PER_DL",
              "insulins" => [%{"id" => ^insulin_id, "defaultDose" => 10}]
            }
          }
        } = response
      )
    end
  end
end
