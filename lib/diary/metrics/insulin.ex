defmodule Diary.Metrics.Insulin do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @derive Inspect
  schema "insulin_metrics" do
    belongs_to :insulin, Diary.Settings.Insulin
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
    |> foreign_key_constraint(:insulin_id)
  end
end
