defmodule DiaryWeb.Features.TitleScreenTest do
  use DiaryWeb.FeatureCase, async: true

  describe "title screen when user is not signed in" do
    setup_session session do
      visit(session, "/")
    end

    feature "has sign in link", %{session: session} do
      assert_has(session, link_to("/sign_in", "Sign in"))
    end

    feature "has sign up link", %{session: session} do
      assert_has(session, link_to("/sign_up", "Sign up"))
    end
  end

  describe "title screen when user is signed in" do
    @email "user@test.com"

    setup_session session do
      session
      |> sign_in(%{email: @email})
      |> visit("/")
    end

    feature "shows current user", %{session: session} do
      assert_has(session, Query.text("Logged in as #{@email}"))
    end

    feature "has dashboard link", %{session: session} do
      assert_has(session, link_to("/home", "Go to Dashboard"))
    end

    feature "has log out link", %{session: session} do
      assert_has(session, link_to("/users/log_out", "Log out"))
    end
  end
end
