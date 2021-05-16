defmodule Diary.Metrics.Insulin do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Inspect
  schema "insulin_metrics" do
    field :medication_id, :integer
    field :notes, :string
    field :taken_at, :naive_datetime
    field :units, :integer
    belongs_to :user, Diary.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(insulin, attrs) do
    insulin
    |> cast(attrs, [:units, :medication_id, :taken_at, :notes])
    |> validate_required([:units, :medication_id, :taken_at])
  end
end
