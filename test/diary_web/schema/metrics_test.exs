defmodule DiaryWeb.Schema.MetricsTest do
  use DiaryWeb.ConnCase

  import Diary.AccountsFixtures
  import Diary.ApiHelpers
  import Diary.SettingsFixtures
  import Diary.MetricsFixtures
  alias Diary.Metrics

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

  describe "mutation deleteInsulinRecord" do
    @describetag :graphql

    @delete_insulin_mutation """
    mutation($id: ID!) {
      insulinRecord: deleteInsulinRecord(id: $id) {
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

    test "deletes insulin record", %{insulin: insulin, conn: conn, user: user} do
      insulin_record = insulin_record_fixture(user.id, insulin.id)

      conn = execute_query(conn, @delete_insulin_mutation, %{"id" => insulin_record.id})

      response = json_response(conn, 200)

      assert get_in(response, ~w[data insulinRecord id]) == to_string(insulin_record.id)

      refute Metrics.get_insulin(insulin_record.id)
    end

    test "when record not found returns error", %{conn: conn} do
      conn = execute_query(conn, @delete_insulin_mutation, %{"id" => "12345"})

      response = json_response(conn, 200)

      assert %{"errors" => [_]} = response
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

  describe "query glucoseRecords" do
    @describetag :graphql

    @glucose_records_query """
    query($limit: Int, $cursor: String, $filters: GlucoseRecordsFilters) {
      glucoseRecords(limit: $limit, cursor: $cursor, filters: $filters) {
        id
        units
        measuredAt
        status
        notes
        cursor
      }
    }
    """

    setup %{conn: conn} do
      user = user_fixture()
      conn = sign_in(conn, user)

      %{user: user, conn: conn}
    end

    test "returns first page", %{conn: conn, user: user} do
      glucose_id1 =
        glucose_record_fixture(
          user.id,
          %{measured_at: ~N[2023-01-01 12:10:00]}
        )
        |> Map.get(:id)
        |> to_string()

      glucose_id2 =
        glucose_record_fixture(
          user.id,
          %{measured_at: ~N[2023-01-01 12:00:00]}
        )
        |> Map.get(:id)
        |> to_string()

      glucose_id3 =
        glucose_record_fixture(
          user.id,
          %{measured_at: ~N[2023-01-01 11:00:00]}
        )
        |> Map.get(:id)
        |> to_string()

      conn = execute_query(conn, @glucose_records_query, limit: 2)

      assert %{"data" => %{"glucoseRecords" => [record1, record2]}} = json_response(conn, 200)

      assert %{"id" => ^glucose_id1, "cursor" => "" <> _} = record1

      assert %{"id" => ^glucose_id2, "cursor" => cursor} = record2

      conn = execute_query(conn, @glucose_records_query, limit: 1, cursor: cursor)

      assert %{"data" => %{"glucoseRecords" => [record3]}} = json_response(conn, 200)

      assert %{"id" => ^glucose_id3} = record3
    end

    test "returns filtered records", %{conn: conn, user: user} do
      _glucose_id1 =
        glucose_record_fixture(
          user.id,
          %{measured_at: ~N[2023-01-01 12:10:00]}
        )
        |> Map.get(:id)
        |> to_string()

      glucose_id2 =
        glucose_record_fixture(
          user.id,
          %{measured_at: ~N[2023-01-01 12:00:00]}
        )
        |> Map.get(:id)
        |> to_string()

      glucose_id3 =
        glucose_record_fixture(
          user.id,
          %{measured_at: ~N[2023-01-01 11:00:00]}
        )
        |> Map.get(:id)
        |> to_string()

      conn =
        execute_query(conn, @glucose_records_query,
          limit: 3,
          filters: %{measuredAtFrom: "2023-01-01T11:00:00Z", measuredAtTo: "2023-01-01T12:00:00Z"}
        )

      assert %{"data" => %{"glucoseRecords" => [record1, record2]}} = json_response(conn, 200)

      assert %{"id" => ^glucose_id2, "cursor" => "" <> _} = record1

      assert %{"id" => ^glucose_id3, "cursor" => _} = record2
    end
  end

  describe "mutation deleteGlucoseRecord" do
    @describetag :graphql

    @delete_glucose_mutation """
    mutation($id: ID!) {
      glucoseRecord: deleteGlucoseRecord(id: $id) {
        id
        units
        measuredAt
      }
    }
    """

    setup %{conn: conn} do
      user = user_fixture()
      conn = sign_in(conn, user)

      %{user: user, conn: conn}
    end

    test "deletes glucose record", %{conn: conn, user: user} do
      glucose_record = glucose_record_fixture(user.id)

      conn = execute_query(conn, @delete_glucose_mutation, %{"id" => glucose_record.id})

      response = json_response(conn, 200)

      assert get_in(response, ~w[data glucoseRecord id]) == to_string(glucose_record.id)

      refute Metrics.get_glucose(glucose_record.id)
    end

    test "when record not found returns error", %{conn: conn} do
      conn = execute_query(conn, @delete_glucose_mutation, %{"id" => "12345"})

      response = json_response(conn, 200)

      assert %{"errors" => [_]} = response
    end
  end
end
