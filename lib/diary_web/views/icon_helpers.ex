defmodule DiaryWeb.IconHelpers do
  import Phoenix.HTML

  def inline_svg(conn, icon, opts \\ []) do
    assigns = [
      class: opts[:class] || "",
      path: DiaryWeb.Router.Helpers.static_path(conn, "/icons/#{icon}.svg#root")
    ]

    ~E"""
    <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="<%= @class %>">
      <use href="<%= @path %>" />
    </svg>
    """
  end
end
