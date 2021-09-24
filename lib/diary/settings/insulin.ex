defmodule Diary.Settings.Insulin do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @derive Inspect
  schema "insulins" do
    field :color, :string
    field :name, :string
    field :settings_id, :integer

    timestamps()
  end

  def changeset(insulin, attrs) do
    insulin
    |> cast(attrs, [:name, :color, :settings_id])
    |> validate_required([:name, :settings_id, :color])
  end
end
