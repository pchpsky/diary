defmodule DiaryWeb.LiveComponents do
  use Phoenix.Component

  attr :breadcrumbs, :list, required: true

  def breadcrumbs(assigns) do
    ~H"""
    <div class="breadcrumbs text">
      <ul>
        <%= for breadcrumb <- Enum.drop(@breadcrumbs, -1) do %>
          <li>
            <%= live_redirect to: breadcrumbs_link_to(breadcrumb) do %>
              <.breadcrumbs_title page={breadcrumb} />
            <% end %>
          </li>
        <% end %>
        <li>
          <span>
            <.breadcrumbs_title page={List.last(@breadcrumbs)} />
          </span>
        </li>
      </ul>
    </div>
    """
  end

  defp breadcrumbs_link_to(:home), do: "/home"
  defp breadcrumbs_link_to(:insulin), do: "/insulin"
  defp breadcrumbs_link_to(:settings), do: "/settings"
  defp breadcrumbs_link_to(:glucose), do: "/glucose"

  defp breadcrumbs_title(%{page: :home} = assigns) do
    ~H"""
    <DiaryWeb.Icons.icon name={:home} class="h-6 w-6" />
    """
  end

  defp breadcrumbs_title(%{page: page}) do
    title =
      case page do
        :insulin -> "Insulin"
        page -> page |> Atom.to_string() |> String.capitalize()
      end

    assigns = %{
      title: title
    }

    ~H"""
    <span><%= @title %></span>
    """
  end

  attr :class, :string, default: ""
  slot :inner_block, required: true

  slot :title do
    attr :class, :string
  end

  slot :actions do
    attr :class, :string
  end

  def card(assigns) do
    ~H"""
    <div class={"card bg-base-100 shadow-lg #{@class}"}>
      <div class="card-body">
        <%= for title <- @title do %>
          <h2 class={"card-title only:mb-0 #{title[:class]}"}><%= render_slot(title) %></h2>
        <% end %>
        <%= render_slot(@inner_block) %>
        <%= for actions <- @actions do %>
          <div class={"card-actions #{actions[:class]}"}><%= render_slot(actions) %></div>
        <% end %>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <input type="checkbox" id={"modal_#{@id}"} class="modal-toggle" phx-hook="Modal" />
    <div class="modal" phx-window-keydown={DiaryWeb.Modal.JS.close(@id)} phx-key="escape">
      <div class="modal-box" phx-click-away={DiaryWeb.Modal.JS.close(@id)}>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  slot :inner_block, required: true

  def modal_actions(assigns) do
    ~H"""
    <div class="modal-action">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  slot :inner_block, required: true

  def modal_title(assigns) do
    ~H"""
    <div class="modal-title mb-4 only:mb-0">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
