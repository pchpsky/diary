defmodule DiaryWeb.MetricsComponents.Records do
  use DiaryWeb, :component

  alias DiaryWeb.MetricsComponents.Divider
  alias DiaryWeb.MetricsComponents.Item

  attr :items, :list, required: true
  slot :inner_block, required: true
  slot :item, required: true

  def stream(assigns) do
    ~H"""
    <div :for={{dom_id, item} <- @items} id={dom_id}>
      <%= case item do %>
        <% %Item{item: item} -> %>
          <%= render_slot(@inner_block, item) %>
        <% %Divider{label: label} -> %>
          <div class="divider">
            <%= label %>
          </div>
      <% end %>
    </div>
    """
  end
end
