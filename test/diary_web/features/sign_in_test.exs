defmodule DiaryWeb.Features.SignInTest do
  use DiaryWeb.FeatureCase, async: true

  import Diary.AccountsFixtures

  @email_field Query.text_field("Email")
  @password_field Query.text_field("Password")
  @submit_button Query.button("Sign in")

  describe "when user is logged in already" do
    setup_session session do
      session
      |> sign_in()
      |> visit("/sign_in")
    end

    @tag :skip
    feature "user is redirected to home page", %{session: session} do
      assert_path(session, "/home")
    end
  end

  describe "whit valid credentials" do
    setup_session session do
      sign_in(session)
    end

    @tag :skip
    feature "user redirected to home page after login", %{session: session} do
      assert_path(session, "/home")
    end
  end

  describe "when user doesn't exist" do
    feature "user is not logged in after attempt", %{session: session} do
      session
      |> visit("/sign_in")
      |> fill_in(@email_field, with: "user@test.com")
      |> fill_in(@password_field, with: "testpass")
      |> click(@submit_button)
      |> assert_path("/sign_in")
      |> assert_text("Invalid email or password")
    end
  end

  describe "when password is wrong" do
    @email "user@test.com"

    setup do
      %{user: user_fixture(%{email: @email, password: "actualpassword"})}
    end

    feature "user is not logged in after attempt", %{session: session} do
      session
      |> visit("/sign_in")
      |> fill_in(@email_field, with: @email)
      |> fill_in(@password_field, with: "testpass")
      |> click(@submit_button)
      |> assert_path("/sign_in")
      |> assert_text("Invalid email or password")
    end
  end
end
