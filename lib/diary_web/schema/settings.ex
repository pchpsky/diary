defmodule DiaryWeb.Schema.Settings do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias DiaryWeb.Resolvers.Settings, as: SettingsResolvers

  @desc "User settings"
  object :settings do
    field :blood_glucose_units, :blood_glucose_units

    field :insulins, list_of(:insulin) do
      @desc "All insulins added by user"

      resolve(&SettingsResolvers.list_insulins/3)
    end
  end

  @desc "Insulin added by user"
  object :insulin do
    field :id, :id
    field :name, :string
    field :color, :string
  end

  object :settings_queries do
    @desc """
    Get user settings
    """

    field :settings, :settings do
      resolve(&SettingsResolvers.get_settings/3)
    end
  end

  @desc """
  Blood glucose units: MG_PER_DL - mg/dL, MMOL_PER_L - mmol/L
  """
  enum(:blood_glucose_units, values: [:mmol_per_l, :mg_per_dl])
end
