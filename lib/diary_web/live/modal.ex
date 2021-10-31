defmodule DiaryWeb.Modal do
  use Phoenix.LiveComponent

  def open(socket) do
    push_event(socket, "modal:open", %{})
  end

  def close(socket) do
    push_event(socket, "modal:close", %{})
  end

  def mount(socket) do
    socket
    |> assign_new(:header, fn -> [] end)
    |> assign_new(:footer, fn -> [] end)
    |> assign_new(:state, fn -> :closed end)
    |> Result.ok()
  end

  def handle_event("modal:close", _, socket) do
    {:noreply, assign(socket, :state, :closed)}
  end

  def handle_event("modal:open", _, socket) do
    {:noreply, assign(socket, :state, :open)}
  end
end
