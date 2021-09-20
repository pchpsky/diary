defmodule DiaryWeb.SettingsLive do
  use DiaryWeb, :live_view

  alias Diary.Settings

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

  def handle_event("inspect", params, socket) do
    {:noreply, socket}
  end
end
