defmodule DiaryWeb.InsulinLive.FormComponent do
  use DiaryWeb, :live_component

  def update(_assigns, socket) do
    {:ok, assign(socket, :expanded, false)}
  end

  def handle_event("toggle_form", _params, socket) do
    {:noreply, assign(socket, :expanded, !socket.assigns.expanded)}
  end
end
