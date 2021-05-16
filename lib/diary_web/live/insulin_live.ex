defmodule DiaryWeb.InsulinLive do
  use DiaryWeb, :live_view

  @impl true
  def mount(_parms, _session, socket) do
    {:ok, assign(socket, :page, :insulin)}
  end
end
