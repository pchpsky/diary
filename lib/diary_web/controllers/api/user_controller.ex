defmodule DiaryWeb.Api.UserController do
  use DiaryWeb, :controller

  alias Diary.Accounts

  action_fallback DiaryWeb.Api.FallbackController

  def create(conn, user_params) do
    with {:ok, user} <- Accounts.register_user(user_params) do

    end
  end
end
