defmodule DiaryWeb.Api.SessionController do
  use DiaryWeb, :controller

  alias Diary.Accounts
  alias Diary.Accounts.User
  alias Diary.Guardian

  def create(conn, %{"email" => email, "password" => password})
      when is_binary(email) and is_binary(password) do
    case Accounts.get_user_by_email_and_password(email, password) do
      %User{} = user ->
        sign_in(conn, user)

      _ ->
        render_invalid_login(conn)
    end
  end

  def create(conn, _), do: render_invalid_login(conn)

  defp sign_in(conn, user) do
    {:ok, token, _full_claims} = Guardian.encode_and_sign(user, %{})
    render(conn, "create.json", token: token)
  end

  defp render_invalid_login(conn) do
    conn
    |> put_status(401)
    |> render("error.json", message: "Invalid email or password")
  end
end
