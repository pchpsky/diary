defmodule DiaryWeb.HeaderComponent do
  use DiaryWeb, :live_component
  alias DiaryWeb.Gettext

  def update(assigns, socket) do
    {:ok, assign(socket, [title: title(assigns.page), page: assigns.page])}
  end

  defp title(:insulin) do
    Gettext.dgettext("titles", "Insulin")
  end

  defp title(page) do
    String.capitalize(page)
  end
end
