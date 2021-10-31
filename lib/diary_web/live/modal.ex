defmodule DiaryWeb.Modal do
  use Phoenix.LiveComponent

  def mount(socket) do
    socket
    |> assign_new(:header, fn -> [] end)
    |> assign_new(:footer, fn -> [] end)
    |> assign_new(:state, fn -> :open end)
    |> Result.ok()
  end

  def handle_event("close", _, socket) do
    {:noreply, assign(socket, :state, :close)}
  end

  def handle_event("open", _, socket) do
    {:noreply, assign(socket, :state, :open)}
  end
end
