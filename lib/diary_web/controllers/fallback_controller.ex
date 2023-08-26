defmodule DiaryWeb.FallbackController do
  use DiaryWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(html: DiaryWeb.ErrorHTML, json: DiaryWeb.ErrorJSON)
    |> render(:show, errors: [%{message: "Invalid email or password"}])
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(DiaryWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end
end
