defmodule DiaryWeb.Settings.EditInsulinForm do
  use DiaryWeb, :live_component

  alias Diary.Settings
  alias DiaryWeb.Toast

  def update(assigns, socket) do
    assigns = [
      insulin: assigns[:insulin],
      insulin_changeset: Settings.change_insulin(assigns[:insulin])
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("save", %{"insulin" => attrs}, socket) do
    insulin = socket.assigns.insulin

    Settings.update_insulin(socket.assigns.insulin, attrs)
    Toast.push(socket, "Updated.")
    Phoenix.PubSub.broadcast!(Diary.PubSub, "settings:insulins:" <> inspect(socket.root_pid), {:updated, insulin.id})

    {:noreply, socket}
  end

  def handle_event("delete", _, socket) do
    insulin = socket.assigns.insulin

    Settings.delete_insulin(socket.assigns.insulin)
    Toast.push(socket, "Deleted.")
    Phoenix.PubSub.broadcast!(Diary.PubSub, "settings:insulins:" <> inspect(socket.root_pid), {:deleted, insulin.id})

    {:noreply, socket}
  end
end
