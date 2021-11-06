defmodule DiaryWeb.SettingsLive do
  use DiaryWeb, :live_view

  alias Diary.Settings
  alias DiaryWeb.Toast
  alias DiaryWeb.Modal
  import DiaryWeb.IconHelpers

  def mount(_arg0, _session, socket) do
    settings = Settings.get_settings(socket.assigns.current_user.id)
    settings_changeset = Settings.change_settings(settings)

    assigns = [
      page: :settings,
      back_path: "/home",
      current_user: socket.assigns.current_user,
      settings: settings,
      settings_changeset: settings_changeset,
      insulins: Settings.list_insulins(settings.id),
      insulin_changeset: new_insulin_changeset()
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("update", %{"user_settings" => settings}, socket) do
    socket.assigns.current_user.id
    |> Settings.get_settings()
    |> Settings.update_settings(settings)
    |> Result.fold(
      fn _ -> Toast.push(socket, "Failed to update settings.") end,
      fn _ -> Toast.push(socket, "Settings updated.") end
    )

    {:noreply, socket}
  end

  def handle_event("delete_insulin", %{"id" => id}, socket) do
    insulin = Diary.Settings.get_insulin!(id)
    Settings.delete_insulin(insulin)
    Toast.push(socket, "Deleted.")

    {:noreply, load_insulins(socket)}
  end

  def handle_event("update_insulin_" <> insulin_id, %{"insulin" => attrs}, socket) do
    insulin_id
    |> Settings.get_insulin!()
    |> Settings.update_insulin(attrs)

    Toast.push(socket, "Insulin updated.")

    {:noreply, load_insulins(socket) |> Modal.close("insulin_#{insulin_id}")}
  end

  def handle_event("create_insulin", %{"insulin" => attrs}, socket) do
    {:ok, _} = Settings.create_insulin(socket.assigns.settings.id, attrs)

    socket =
      socket
      |> load_insulins()
      |> assign(:insulin_changeset, nil)
      |> Modal.close("insulin_add")

    Toast.push(socket, "Insulin created.")

    {:noreply, socket}
  end

  def handle_event("new_insulin", _, socket) do
    {:noreply, socket |> assign(:insulin_changeset, new_insulin_changeset()) |> Modal.open("insulin_add")}
  end

  defp load_insulins(socket) do
    assign(socket, :insulins, Settings.list_insulins(socket.assigns.settings))
  end

  defp new_insulin_changeset() do
    Settings.change_insulin(%Settings.Insulin{color: "#99c1f1", name: ""})
  end
end
