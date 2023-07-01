defmodule DiaryWeb.Schema.AccountsTest do
  use DiaryWeb.ConnCase

  import Diary.AccountsFixtures
  import Diary.ApiHelpers
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

  describe "mutation createUser" do
    @describetag :graphql

    @create_user_mutation """
    mutation($email: String!, $password: String!) {
      session: createUser(email: $email, password: $password) {
        token
        user {
          email
        }
      }
    }
    """

    test "creates user", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, "/graph", %{
          "query" => @create_user_mutation,
          "variables" => %{
            "email" => email,
            "password" => valid_user_password()
          }
        })

      response = json_response(conn, 200)

      assert(
        %{
          "data" => %{
            "session" => %{
              "user" => %{
                "email" => ^email
              }
            }
          }
        } = response
      )
    end

    test "when user already exists returns error", %{conn: conn} do
      user = user_fixture()

      conn =
        post(conn, "/graph", %{
          "query" => @create_user_mutation,
          "variables" => %{
            "email" => user.email,
            "password" => valid_user_password()
          }
        })

      response = json_response(conn, 200)

      assert(
        %{
          "errors" => [
            %{
              "fields" => %{
                "email" => ["has already been taken"]
              }
            }
          ]
        } = response
      )
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

    test "returns auth token", %{conn: conn, creds: creds} do
      conn =
        post(conn, "/graph", %{
          "query" => @login_mutation,
          "variables" => creds
        })

      response = json_response(conn, 200)

      email = creds.email

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

  describe "mutation completeOnboarding" do
    @describetag :graphql

    @onboarding_mutation """
    mutation($onboardingCompletedAt: NaiveDateTime!) {
      user: completeOnboarding(completedAt: $onboardingCompletedAt) {
        email
        onboardingCompletedAt
      }
    }
    """

    setup %{conn: conn} do
      user = user_fixture()
      conn = sign_in(conn, user)
      %{user: user, conn: conn}
    end

    test "completes onboarding", %{conn: conn} do
      completed_at =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.truncate(:second)
        |> NaiveDateTime.to_iso8601()

      conn =
        post(conn, "/graph", %{
          "query" => @onboarding_mutation,
          "variables" => %{
            "onboardingCompletedAt" => completed_at
          }
        })

      response = json_response(conn, 200)

      assert %{
               "data" => %{
                 "user" => %{
                   "onboardingCompletedAt" => ^completed_at
                 }
               }
             } = response
    end
  end
end
