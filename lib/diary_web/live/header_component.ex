defmodule DiaryWeb.HeaderComponent do
  use DiaryWeb, :live_component
  alias DiaryWeb.Gettext

  def render(assigns) do
    ~L"""
    <header class="bg-th-<%= @page %> h-9 flex">
      <div class="flex-1">
      </div>
      <div class="flex-none flex items-center justify-center">
        <h1 class="font-semibold text-lg"><%= @title %></h1>
      </div>
      <div class="flex-1">
      </div>
    </header>
    """
  end

  def update(assigns, socket) do
    {:ok, assign(socket, [title: title(assigns.page), page: assigns.page])}
  end

  defp title(:insulin) do
    Gettext.dgettext("titles", "Insulin")
  end

  defp title(page) do
    page
    |> Atom.to_string()
    |> String.capitalize()
  end
end
