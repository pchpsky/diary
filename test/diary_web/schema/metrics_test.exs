defmodule DiaryWeb.Schema.MetricsTest do
  use DiaryWeb.ConnCase

  import Diary.AccountsFixtures
  import Diary.ApiHelpers
  import Diary.SettingsFixtures
  import Diary.MetricsFixtures

  describe "query insulinRecords" do
    @describetag :graphql

    @insulin_records_query """
    query($limit: Int, $cursor: String) {
      insulinRecords(limit: $limit, cursor: $cursor) {
        id
        insulinId
        insulin {
          name
          color
        }
        units
        takenAt
        notes
        cursor
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

    test "returns first page", %{conn: conn, user: user, insulin: insulin} do
      insulin_id1 =
        insulin_record_fixture(
          user.id,
          insulin.id,
          %{taken_at: ~N[2023-01-01 12:10:00]}
        )
        |> Map.get(:id)
        |> to_string()

      insulin_id2 =
        insulin_record_fixture(
          user.id,
          insulin.id,
          %{taken_at: ~N[2023-01-01 12:00:00]}
        )
        |> Map.get(:id)
        |> to_string()

      insulin_id3 =
        insulin_record_fixture(
          user.id,
          insulin.id,
          %{taken_at: ~N[2023-01-01 11:00:00]}
        )
        |> Map.get(:id)
        |> to_string()

      conn = execute_query(conn, @insulin_records_query, limit: 2)

      assert %{"data" => %{"insulinRecords" => [record1, record2]}} = json_response(conn, 200)

      assert %{"id" => ^insulin_id1, "cursor" => "" <> _} = record1

      assert %{"id" => ^insulin_id2, "cursor" => cursor} = record2

      conn = execute_query(conn, @insulin_records_query, limit: 1, cursor: cursor)

      assert %{"data" => %{"insulinRecords" => [record3]}} = json_response(conn, 200)

      assert %{"id" => ^insulin_id3} = record3
    end
  end

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

      conn = execute_query(conn, @record_insulin_mutation, %{"input" => input})

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

      conn = execute_query(conn, @record_glucose_mutation, %{"input" => input})

      response = json_response(conn, 200)

      assert %{"id" => "" <> _} = response["data"]["glucoseRecord"]
    end
  end
end
