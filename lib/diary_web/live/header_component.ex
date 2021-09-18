defmodule DiaryWeb.HeaderComponent do
  @moduledoc false
  use DiaryWeb, :live_component
  alias DiaryWeb.Gettext
  import DiaryWeb.IconHelpers

  def render(assigns) do
    ~H"""
    <header class="h-12 flex border-b border-grey-900 z-0" style={"background-color: var(--bgc-#{@page}-header)"}>
      <div class="flex-1">
      </div>
      <div class="flex-none flex items-center justify-center">
        <h1 class="font-semibold text-lg"><%= @title %></h1>
      </div>
      <div class="flex-1 flex flex-row-reverse items-center">
        <div class="mr-2 relative" x-data="{ open: false }">
          <button
            style={"background-color: var(--bgc-#{@page}-header)"}
            class="hover:bg-grey-500 hover:bg-opacity-20 ring-1 ring-grey-700 ring-opacity-20 p-1 rounded cursor-pointer"
            :class="open ? 'bg-grey-500 bg-opacity-30 ring-1 ring-grey-800' : 'bg-grey-900'"
            @click="open = !open"
            @keydown.escape.window="open = false"
            @click.away="open = false"
          >
            <%= inline_svg(@socket, "cog", class: "h-6 w-6") %>
          </button>
          <div
            x-cloak
            x-show="open"
            x-transition:enter="transition ease-out duration-100"
            x-transition:enter-start="transform opacity-0 scale-95"
            x-transition:enter-end="transform opacity-100 scale-100"
            x-transition:leave="transition ease-in duration-75"
            x-transition:leave-start="transform opacity-100 scale-100"
            x-transition:leave-end="transform opacity-0 scale-95"
            class="flex flex-col origin-top-right absolute right-0 mt-1 w-40 rounded bg-th-bgc-main ring-1 ring-grey-800 focus:outline-none z-20"
          >
            <a class="flex items-center h-8 p-5 pl-2 text-white bg-grey-500 bg-opacity-20 hover:bg-grey-600 hover:bg-opacity-20 border-b border-grey-800" href="#">
              <%= inline_svg(@socket, "adjustments", class: "h-4 w-4") %><span class="pl-2">User settings</span>
            </a>
            <%= link(to: "/users/log_out", method: :delete, class: "flex items-center h-8 p-5 pl-2 text-white bg-grey-500 bg-opacity-20 hover:bg-grey-600 hover:bg-opacity-20") do %>
              <%= inline_svg(@socket, "logout", class: "h-4 w-4") %><span class="pl-2">Log out</span>
            <% end %>
          </div>
        </div>
      </div>
    </header>
    """
  end

  def update(assigns, socket) do
    {:ok, assign(socket, title: title(assigns.page), page: assigns.page)}
  end

  defp title(nil), do: ""
  defp title(:home), do: "Diary"

  defp title(:insulin) do
    Gettext.dgettext("titles", "Insulin")
  end

  defp title(page) do
    page
    |> Atom.to_string()
    |> String.capitalize()
  end
end
