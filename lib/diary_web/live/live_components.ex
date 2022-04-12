defmodule DiaryWeb.LiveComponents do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias LiveBeatsWeb.Router.Helpers, as: Routes
  alias Phoenix.LiveView.JS

  def icon(%{name: :syringe} = assigns) do
    assigns = assign_new(assigns, :class, fn -> "w-4 h-4 inline-block" end)

    ~H"""
    <svg
      aria-hidden="true"
      focusable="false"
      data-prefix="fas"
      data-icon="syringe"
      role="img"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 512 512"
      class={@class}
    >
      <path
        fill="currentColor"
        d="M504.1 71.03l-64-64c-9.375-9.375-24.56-9.375-33.94 0s-9.375 24.56 0 33.94L422.1 56L384 94.06l-55.03-55.03c-9.375-9.375-24.56-9.375-33.94 0c-8.467 8.467-8.873 21.47-2.047 30.86l149.1 149.1C446.3 222.1 451.1 224 456 224c6.141 0 12.28-2.344 16.97-7.031c9.375-9.375 9.375-24.56 0-33.94L417.9 128L456 89.94l15.03 15.03C475.7 109.7 481.9 112 488 112s12.28-2.344 16.97-7.031C514.3 95.59 514.3 80.41 504.1 71.03zM208.8 154.1l58.56 58.56c6.25 6.25 6.25 16.38 0 22.62C264.2 238.4 260.1 240 256 240S247.8 238.4 244.7 235.3L186.1 176.8L144.8 218.1l58.56 58.56c6.25 6.25 6.25 16.38 0 22.62C200.2 302.4 196.1 304 192 304S183.8 302.4 180.7 299.3L122.1 240.8L82.75 280.1C70.74 292.1 64 308.4 64 325.4v88.68l-56.97 56.97c-9.375 9.375-9.375 24.56 0 33.94C11.72 509.7 17.86 512 24 512s12.28-2.344 16.97-7.031L97.94 448h88.69c16.97 0 33.25-6.744 45.26-18.75l187.6-187.6l-149.1-149.1L208.8 154.1z"
      >
      </path>
    </svg>
    """
  end

  def icon(assigns) do
    assigns =
      assigns
      |> assign_new(:outlined, fn -> false end)
      |> assign_new(:class, fn -> "w-4 h-4 inline-block" end)

    ~H"""
    <%= if @outlined do %>
      <%= apply(Heroicons.Outline, @name, [assigns_to_attributes(assigns, [:outlined, :name])]) %>
    <% else %>
      <%= apply(Heroicons.Solid, @name, [assigns_to_attributes(assigns, [:outlined, :name])]) %>
    <% end %>
    """
  end

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

  defp breadcrumbs_title(%{page: :home} = assigns) do
    ~H"""
    <.icon name={:home} class="h-6 w-6" />
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

  def card(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:title, fn -> [] end)

    ~H"""
    <div class={"card bg-base-100 shadow-lg #{@class}"}>
      <div class="card-body">
        <%= for title <- @title do %>
          <h2 class={"card-title only:mb-0 #{title[:class]}"}><%= render_slot(title) %></h2>
        <% end %>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

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

  def modal_actions(assigns) do
    ~H"""
    <div class="modal-action">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def modal_title(assigns) do
    ~H"""
    <div class="modal-title mb-4 only:mb-0">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
