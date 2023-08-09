defmodule Diary.Settings.Insulin do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @derive Inspect
  schema "insulins" do
    field :color, :string
    field :name, :string
    field :default_dose, :integer
    field :settings_id, :integer
    field :deleted_at, :naive_datetime

    timestamps()
  end

  def changeset(insulin, attrs) do
    insulin
    |> cast(attrs, [:name, :color, :settings_id, :default_dose, :deleted_at])
    |> validate_required([:name, :settings_id, :color])
  end
end
