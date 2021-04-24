defmodule DiaryWeb.HomeController do
  use DiaryWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
