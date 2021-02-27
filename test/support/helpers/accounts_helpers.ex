defmodule DiaryWeb.AccountsHelpers do
  use Wallaby.DSL
  import Diary.AccountsFixtures

  @email_field Query.text_field("Email")
  @password_field Query.text_field("Password")
  @submit_button Query.button("Log in")

  def sign_in(session), do: sign_in(session, create_user())

  def sign_in(session, attrs) do
    user = create_user(attrs)

    session
    |> visit("/sign_in")
    |> fill_in(@email_field, with: user.email)
    |> fill_in(@password_field, with: user.password)
    |> click(@submit_button)
  end

  def create_user(attrs \\ %{}) do
    users_attrs =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: valid_user_password()
      })
    user_fixture(users_attrs)
    users_attrs
  end
end
