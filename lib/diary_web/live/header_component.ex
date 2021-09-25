defmodule DiaryWeb.HeaderComponent do
  @moduledoc false
  use DiaryWeb, :live_component
  alias DiaryWeb.Gettext
  import DiaryWeb.IconHelpers

  def update(assigns, socket) do
    {:ok,
     assign(socket,
       title: assigns[:title] || title(assigns.page),
       page: assigns.page,
       back_path: assigns[:back_path]
     )}
  end

  defp maybe_back_link(assigns) do
    ~H"""
    <%= if assigns[:back_path] do %>
      <%= live_redirect to: assigns[:back_path], class: "ml-3" do %>
        <%= inline_svg(@socket, "arrow-left", class: "h-6 w-6") %>
      <% end %>
    <% end %>
    """
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

  defp header_color(:settings), do: header_color(:home)
  defp header_color(nil), do: header_color(:home)
  defp header_color(page), do: "--bgc-#{page}-header"
end
