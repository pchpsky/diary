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
end
