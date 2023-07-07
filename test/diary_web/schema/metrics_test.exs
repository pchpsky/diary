defmodule DiaryWeb.Schema.MetricsTest do
  use DiaryWeb.ConnCase

  import Diary.AccountsFixtures
  import Diary.ApiHelpers
  import Diary.SettingsFixtures

  describe "mutation recordInsulin" do
    @describetag :graphql

    @record_insulin_mutation """
    mutation($input: InsulinRecordInput!) {
      insulinRecord: recordInsulin(input: $input) {
        id
        insulinId
        units
        takenAt
        notes
      }
    }
    """

    setup %{conn: conn} do
      user = user_fixture()
      conn = sign_in(conn, user)

      settings = settings_fixture(user.id)
      insulin = insulin_fixture(settings.id)

      %{user: user, insulin: insulin, conn: conn}
    end

    test "creates insulin record", %{insulin: insulin, conn: conn} do
      input = %{
        "units" => 10.0,
        "insulinId" => insulin.id,
        "takenAt" => "2023-01-01T00:00:00Z",
        "notes" => "Some notes"
      }

      conn =
        post(conn, "/graph", %{
          "query" => @record_insulin_mutation,
          "variables" => %{"input" => input}
        })

      response = json_response(conn, 200)

      assert %{"id" => "" <> _} = response["data"]["insulinRecord"]
    end
  end

  describe "mutation recordGlucose" do
    @describetag :graphql

    @record_glucose_mutation """
    mutation($input: GlucoseRecordInput!) {
      glucoseRecord: recordGlucose(input: $input) {
        id
        status
        units
        measuredAt
        notes
      }
    }
    """

    setup %{conn: conn} do
      user = user_fixture()
      conn = sign_in(conn, user)

      %{user: user, conn: conn}
    end

    test "creates glucose record", %{conn: conn} do
      input = %{
        "units" => 10.0,
        "status" => "GENERAL",
        "measuredAt" => "2023-01-01T00:00:00Z",
        "notes" => "Some notes"
      }

      conn =
        post(conn, "/graph", %{
          "query" => @record_glucose_mutation,
          "variables" => %{"input" => input}
        })

      response = json_response(conn, 200)

      assert %{"id" => "" <> _} = response["data"]["glucoseRecord"]
    end
  end
end
