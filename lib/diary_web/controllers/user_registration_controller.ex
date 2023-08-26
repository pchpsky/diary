defmodule DiaryWeb.UserRegistrationController do
  use DiaryWeb, :controller

  alias Diary.Accounts
  alias Diary.Accounts.User
  alias DiaryWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        # TODO: remove this once there is a proper onboarding flow
        Accounts.complete_onboarding(user, NaiveDateTime.utc_now())

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
