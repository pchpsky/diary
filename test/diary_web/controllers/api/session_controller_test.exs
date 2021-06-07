defmodule DiaryWeb.Api.SessionControllerTest do
  use DiaryWeb.ConnCase, async: true

  import Diary.AccountsFixtures

  setup do
    user = user_fixture()
    %{
      user: user,
      creds: %{email: user.email, password: valid_user_password()}
    }
  end

  describe "POST /api/session" do
    @tag :api
    test "when credentials are invalid responds with 401", %{conn: conn, creds: creds} do
      conn = post(
        conn,
        Routes.session_path(conn, :create),
        %{creds | password: "notavalidpass"}
      )
      assert %{"message" => "Invalid email or password"} = json_response(conn, 401)
    end

    @tag :api
    test "when credentials are valid responds with 200", %{conn: conn, creds: creds} do
      conn = post(conn, Routes.session_path(conn, :create), creds)
      assert %{"token" => "" <> _} = json_response(conn, 200)
    end
  end
end
