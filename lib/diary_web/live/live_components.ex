defmodule DiaryWeb.LiveComponents do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias LiveBeatsWeb.Router.Helpers, as: Routes
  alias Phoenix.LiveView.JS

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
          <span><.breadcrumbs_title page={List.last(@breadcrumbs)} /></span>
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

  defp breadcrumb_item(%{name: :home} = assigns) do
    ~H"""
    <li>
      <%= live_redirect to: "/home" do %>
        <.icon name={:home} />
      <% end %>
    </li>
    """
  end

  defp breadcrumb_item(%{name: :insulin} = assigns) do
    ~H"""
    <li>
      <%= live_redirect to: "/home" do %>
        <.icon name={:home} />
      <% end %>
    </li>
    """
  end
end
