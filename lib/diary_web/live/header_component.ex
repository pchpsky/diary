defmodule DiaryWeb.HeaderComponent do
  @moduledoc false
  use DiaryWeb, :live_component
  alias DiaryWeb.Gettext
  import DiaryWeb.IconHelpers

  def render(assigns) do
    ~L"""
    <header class="h-9 flex" style="background-color: var(--bgc-<%= @page %>-header)">
      <div class="flex-1">
      </div>
      <div class="flex-none flex items-center justify-center">
        <h1 class="font-semibold text-lg"><%= @title %></h1>
      </div>
      <div class="flex-1 flex flex-row-reverse items-center">
        <div class="pr-2">
          <%= inline_svg(@socket, "cog", class: "h-6 w-6") %>
        </div>
      </div>
    </header>
    """
  end

  def update(assigns, socket) do
    {:ok, assign(socket, title: title(assigns.page), page: assigns.page)}
  end

  defp title(nil), do: ""
  defp title(:home), do: ""

  defp title(:insulin) do
    Gettext.dgettext("titles", "Insulin")
  end

  defp title(page) do
    page
    |> Atom.to_string()
    |> String.capitalize()
  end
end
