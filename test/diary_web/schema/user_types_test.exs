defmodule DiaryWeb.Schema.UserTypesTest do
  use DiaryWeb.ConnCase

  import Diary.AccountsFixtures
  import Diary.Guardian

  describe "query currentUser" do
    @describetag :graphql

    @user_query """
    {
      currentUser {
        email
      }
    }
    """

    setup do
      user = user_fixture()
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
      %{token: token, user: user}
    end

    test "returns current user", %{conn: conn, token: token, user: %{email: email}} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> post("/graph", %{"query" => @user_query})

      response = json_response(conn, 200)

      assert(
        %{
          "data" => %{
            "currentUser" => %{
              "email" => ^email
            }
          }
        } = response
      )
    end

    test "responds with error when not authorized", %{conn: conn} do
      conn = post(conn, "/graph", %{"query" => @user_query})

      response = json_response(conn, 200)

      assert([%{"message" => "Not Authorized"}] = response["errors"])
    end
  end

  describe "mutation createSession" do
    @describetag :graphql

    @login_mutation """
    mutation($email: String!, $password: String!) {
      session: createSession(email: $email, password: $password) {
        token
        user {
          email
        }
      }
    }
    """

    setup do
      user = user_fixture()

      %{
        user: user,
        creds: %{email: user.email, password: valid_user_password()}
      }
    end

    test "returns auth token", %{conn: conn, creds: %{email: email} = creds} do
      conn =
        post(conn, "/graph", %{
          "query" => @login_mutation,
          "variables" => creds
        })

      response = json_response(conn, 200)

      assert(
        %{
          "data" => %{
            "session" => %{
              "token" => "" <> _,
              "user" => %{"email" => ^email}
            }
          }
        } = response
      )
    end

    test "when credentials invalid responds with error",
         %{conn: conn, creds: creds} do
      conn =
        post(conn, "/graph", %{
          "query" => @login_mutation,
          "variables" => %{creds | password: "notavalidpass"}
        })

      response = json_response(conn, 200)

      assert([%{"message" => "Incorrect email or password"}] = response["errors"])
    end
  end
end
