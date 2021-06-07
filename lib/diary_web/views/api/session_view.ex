defmodule DiaryWeb.Api.SessionView do
  use DiaryWeb, :view

  def render("create.json", %{token: token}) do
    %{
      token: token
    }
  end

  def render("error.json", %{message: message}) do
    %{
      message: message
    }
  end
end
