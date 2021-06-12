defmodule DiaryWeb.Api.UserView do
  use DiaryWeb, :view

  def render("create.json", %{token: token, email: email}) do
    %{
      token: token,
      email: email
    }
  end
end
