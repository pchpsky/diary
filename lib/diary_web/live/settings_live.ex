defmodule DiaryWeb.SettingsLive do
  use DiaryWeb, :live_view

  def render(assigns) do
    ~H"""
    Settings of
    <%= assigns.current_user.email %>
    """
  end

  def mount(_arg0, _session, socket) do
    assigns = [
      page: :settings,
      back_path: "/home",
      current_user: socket.assigns.current_user
    ]

    {:ok, assign(socket, assigns)}
  end
end
