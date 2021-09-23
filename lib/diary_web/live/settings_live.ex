defmodule DiaryWeb.SettingsLive do
  use DiaryWeb, :live_view

  alias Diary.Settings
  alias DiaryWeb.Toast

  def mount(_arg0, _session, socket) do
    settings_changeset =
      socket.assigns.current_user.id
      |> Settings.get_settings()
      |> Settings.change_settings()

    assigns = [
      page: :settings,
      back_path: "/home",
      current_user: socket.assigns.current_user,
      settings_changeset: settings_changeset
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("inspect", %{"user_settings" => settings}, socket) do
    socket.assigns.current_user.id
    |> Settings.get_settings()
    |> Settings.update_settings(settings)
    |> Result.fold(
      fn _ -> Toast.push(socket, "Failed to update settings.") end,
      fn _ -> Toast.push(socket, "Settings updated.") end
    )

    {:noreply, socket}
  end
end
