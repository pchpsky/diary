defmodule DiaryWeb.Features.SignUpTest do
  use DiaryWeb.FeatureCase, async: true

  import Diary.AccountsFixtures

  @email_field Query.css("#user_email")
  @password_field Query.css("#user_password")
  @confirmation_field Query.css("#user_password_confirmation")
  @submit_button Query.button("Submit")

  describe "when user is logged in already" do
    setup_session session do
      session
      |> sign_in()
      |> visit("/sign_up")
    end

    feature "user is redirected to home page", %{session: session} do
      assert_path(session, "/home")
    end
  end

  describe "whith valid parameteres" do
    setup_session session do
      session
      |> visit("/sign_up")
      |> fill_in(@email_field, with: "user@test.com")
      |> fill_in(@password_field, with: "validpassword")
      |> fill_in(@confirmation_field, with: "validpassword")
      |> click(@submit_button)
    end

    feature "user redirected to home page after login", %{session: session} do
      session
      |> assert_text("User created successfully.")
      |> assert_path("/home")
    end
  end

  describe "when email already in use" do
    @email "user@test.com"

    setup do
      %{user: user_fixture(%{email: @email, password: "actualpassword"})}
    end

    setup_session session do
      session
      |> visit("/sign_up")
      |> fill_in(@email_field, with: @email)
      |> fill_in(@password_field, with: "validpassword")
      |> fill_in(@confirmation_field, with: "validpassword")
      |> click(@submit_button)
    end

    feature "user is not created", %{session: session} do
      session
      |> assert_path("/sign_up")
      |> assert_text("Oops, something went wrong! Please check the errors below.")
      |> assert_text("has already been taken")
    end
  end

  describe "when password is invalid" do
    setup_session session do
      session
      |> visit("/sign_up")
      |> fill_in(@email_field, with: "user@test.com")
      |> fill_in(@password_field, with: "invldp")
      |> fill_in(@confirmation_field, with: "invldp")
      |> click(@submit_button)
    end

    feature "user is not created", %{session: session} do
      session
      |> assert_path("/sign_up")
      |> assert_text("Oops, something went wrong! Please check the errors below.")
      |> assert_text("should be at least 8 character(s)")
    end
  end

  describe "when password " do
    setup_session session do
      session
      |> visit("/sign_up")
      |> fill_in(@email_field, with: "user@test.com")
      |> fill_in(@password_field, with: "invldp")
      |> fill_in(@confirmation_field, with: "invldp")
      |> click(@submit_button)
    end

    feature "user is not created", %{session: session} do
      session
      |> assert_path("/sign_up")
      |> assert_text("Oops, something went wrong! Please check the errors below.")
      |> assert_text("should be at least 8 character(s)")
    end
  end
end
