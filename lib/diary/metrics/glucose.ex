defmodule Diary.Metrics.Glucose do
  import EctoEnum

  defenum(GlucoseRecordStatus, general: 0, fasting: 1, pre_meal: 2, post_meal: 3, before_sleep: 4)

  use Ecto.Schema
  import Ecto.Changeset

  schema "glucose_metrics" do
    field :measured_at, :naive_datetime
    field :notes, :string
    field :status, GlucoseRecordStatus
    field :units, :float
    belongs_to :user, Diary.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(glucose, attrs) do
    glucose
    |> cast(attrs, [:units, :status, :notes, :measured_at])
    |> validate_required([:units, :status, :measured_at])
  end
end
