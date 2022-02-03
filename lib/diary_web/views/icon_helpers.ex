# TODO: Use icon helper instead
defmodule DiaryWeb.IconHelpers do
  use Phoenix.Component

  def inline_svg(conn, icon, opts \\ []) do
    assigns = %{
      class: opts[:class] || "",
      path: DiaryWeb.Router.Helpers.static_path(conn, "/icons/#{icon}.svg#root")
    }

    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class={@class}>
      <use href={@path}/>
    </svg>
    """
  end
end
