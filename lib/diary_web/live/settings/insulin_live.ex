defmodule DiaryWeb.Settings.InsulinLive do
  use DiaryWeb, :live_view

  def render(assigns) do
    ~H"""
    """
  end

  def view_insulin(assigns) do
    ~H"""
    <div class="p-3 flex items-center">
      <div class="w-4 h-4 inline-block mr-3 rounded-full" style={"background-color: #{@insulin.color}"}></div>
      <%= @insulin.name %>
    </div>
    """
  end
end
