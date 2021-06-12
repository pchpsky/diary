defmodule DiaryWeb.Api.UserControllerTest do
  use DiaryWeb.ConnCase, async: true

  import Diary.AccountsFixtures

  describe "POST /api/users" do
    @tag :api
    test "when user params are valid responds with 200", %{conn: conn} do
      email = unique_user_email()
      password = valid_user_password()
      user_params = %{
        "email" => email,
        "password" => password,
        "password_confirmation" => password
      }

      conn = post(conn, Routes.user_path(conn, :create), %{"user" => user_params})

      assert %{"token" => "" <> _, "email" => email} = json_response(conn, 200)
    end

    @tag :api
    test "when user params are invalid responds with 422", %{conn: conn} do
      email = unique_user_email()
      password = valid_user_password()
      user_params = %{
        "email" => email,
        "password" => password,
        "password_confirmation" => "pass"
      }
    end
  end
end
