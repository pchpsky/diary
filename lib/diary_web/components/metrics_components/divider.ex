defmodule DiaryWeb.MetricsComponents.Divider do
  @enforce_keys [:label, :dom_id]
  defstruct [:label, :dom_id]

  def new(label, dom_id) do
    %__MODULE__{label: label, dom_id: dom_id}
  end
end
