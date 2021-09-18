defmodule DiaryWeb.InsulinLive do
  @moduledoc false
  use DiaryWeb, :live_view
  alias DiaryWeb.InsulinLive.FormComponent
  alias Diary.Metrics

  @impl true
  def mount(_parms, _session, socket) do
    changeset = Metrics.change_insulin(%Metrics.Insulin{})
    {:ok, assign(socket, page: :insulin, changeset: changeset, back_path: "/home")}
  end
end
