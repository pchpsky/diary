defmodule DiaryWeb.Resolvers.Accounts do
  @moduledoc false
  alias Diary.Accounts
  alias Diary.Accounts.User
  alias Diary.GoogleIdToken
  import DiaryWeb.Schema.ChangesetHelpers

  def current_user(_parent, _args, %{context: %{current_user: user}}),
    do: Result.ok(user)

  def create_user(_parent, args, _context) do
    args
    |> Accounts.register_user()
    |> Result.map_error(&render_invalid_changeset/1)
    |> Result.map(fn user ->
      {:ok, jwt, _full_claims} = Diary.Guardian.encode_and_sign(user)
      %{token: jwt, user: user}
    end)
  end

  def login_by_google_id_token(_parent, %{id_token: id_token}, _context) do
    {:ok, %{"email" => email}} = GoogleIdToken.verify(id_token)

    user = Accounts.get_user_by_email(email) || create_user_for_google_id_token(email)

    {:ok, jwt, _full_claims} = Diary.Guardian.encode_and_sign(user)

    Result.ok(%{token: jwt, user: user})
  end

  def login(_parent, %{email: email, password: password}, _resolution) do
    with %User{} = user <- Accounts.get_user_by_email_and_password(email, password),
         {:ok, jwt, _full_claims} <- Diary.Guardian.encode_and_sign(user) do
      Result.ok(%{token: jwt, user: %{email: user.email}})
    else
      _ -> Result.error(%{message: "Incorrect email or password", code: 401})
    end
  end

  def complete_onboarding(_parent, %{completed_at: completed_at}, %{context: %{current_user: user}}) do
    user
    |> Accounts.complete_onboarding(completed_at)
    |> Result.map_error(&render_invalid_changeset/1)
  end

  defp create_user_for_google_id_token(email) do
    password = gen_password()
    {:ok, user} = Accounts.register_user(%{email: email, password: password})
    user
  end

  defp gen_password(length \\ 32) do
    1..length
    |> Enum.map(fn _ -> Enum.random(Enum.to_list(?A..?Z) ++ Enum.to_list(?a..?z)) end)
    |> List.to_string()
  end
end
