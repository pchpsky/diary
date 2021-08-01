defmodule Diary.Settings.Insulin do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @derive Inspect
  schema "insulins" do
    field :color, :string
    field :name, :string

    timestamps()
  end

  def changeset(insulin, attrs) do
    insulin
    |> cast(attrs, [:name, :color])
    |> validate_required([:name])
  end
end
