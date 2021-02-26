defmodule DiaryWeb.Features.TitleScreenTest do
  use DiaryWeb.FeatureCase, async: true

  describe "title screen" do
    feature "has sign in button", %{session: session} do
      session
      |> visit("/")
      |> assert_has(Query.text("Sign in"))
    end
  end
end
