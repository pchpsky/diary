defmodule DiaryWeb.MetricsComponents.Item do
  @enforce_keys [:item, :dom_id]
  defstruct [:item, :dom_id]

  def new(item, dom_id) do
    %__MODULE__{item: item, dom_id: dom_id}
  end
end
