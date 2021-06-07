defmodule DiaryWeb.Api.FallbackController do
  use DiaryWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(DiaryWeb.Api.ChangesetView)
    |> render("error.json", changeset: changeset)
  end
end
