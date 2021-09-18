defmodule DiaryWeb.SettingsLive do
  use DiaryWeb, :live_view

  def render(assigns) do
    ~H"""
    Settings
    """
  end

  def mount(_arg0, _session, socket) do
    {:ok, assign(socket, page: :settings, back_path: "/home")}
  end
end
