defmodule Diary.Settings.UserSettings do
  import EctoEnum

  defenum(BloodGlucoseUnits, mmol_per_l: 0, mg_per_dl: 1)

  use Ecto.Schema
  import Ecto.Changeset

  schema "user_settings" do
    field :blood_glucose_units, BloodGlucoseUnits
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(user_settings, attrs) do
    user_settings
    |> cast(attrs, [:blood_glucose_units, :user_id])
    |> validate_required([:user_id])
  end
end
