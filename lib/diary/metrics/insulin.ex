defmodule Diary.Metrics.Insulin do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @derive Inspect
  schema "insulin_metrics" do
    field :insulin_id, :integer
    field :notes, :string
    field :taken_at, :naive_datetime
    field :units, :float
    belongs_to :user, Diary.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(insulin, attrs) do
    insulin
    |> cast(attrs, [:units, :insulin_id, :taken_at, :notes])
    |> validate_required([:units, :insulin_id, :taken_at])
  end
end
