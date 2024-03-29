defmodule DiaryWeb.Schema.Settings do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias DiaryWeb.Resolvers.Settings, as: SettingsResolvers

  @desc "User settings"
  object :settings do
    field :blood_glucose_units, :blood_glucose_units

    field :insulins, non_null(list_of(:insulin)) do
      @desc "All insulins added by user"

      resolve &SettingsResolvers.list_insulins/3
    end
  end

  @desc "Insulin added by user"
  object :insulin do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :color, non_null(:string)
    field :default_dose, :integer
  end

  object :settings_queries do
    @desc """
    Get user settings
    """

    field :settings, non_null(:settings) do
      resolve &SettingsResolvers.get_settings/3
    end
  end

  object :settings_mutations do
    @desc """
    Update user settings
    """

    field :update_settings, non_null(:settings) do
      arg :input, non_null(:settings_input)

      resolve &SettingsResolvers.update_settings/3
    end

    field :create_insulin, non_null(:insulin) do
      arg :input, non_null(:insulin_input)

      resolve &SettingsResolvers.create_insulin/3
    end

    field :create_insulins, non_null(list_of(:insulin)) do
      arg :input, non_null(list_of(:insulin_input))

      resolve &SettingsResolvers.create_insulins/3
    end

    field :update_insulin, non_null(:insulin) do
      arg :id, non_null(:id)
      arg :input, non_null(:insulin_input)

      resolve &SettingsResolvers.update_insulin/3
    end

    field :delete_insulin, non_null(:insulin) do
      arg :id, non_null(:id)

      resolve &SettingsResolvers.delete_insulin/3
    end
  end

  @desc """
  Blood glucose units: MG_PER_DL - mg/dL, MMOL_PER_L - mmol/L
  """
  enum :blood_glucose_units, values: [:mmol_per_l, :mg_per_dl]

  @desc """
  Settings input object for update
  """
  input_object :settings_input do
    field :blood_glucose_units, non_null(:blood_glucose_units)
  end

  @desc """
  Input object for creating/updating insulins
  """
  input_object :insulin_input do
    field :name, non_null(:string)
    field :color, non_null(:string)
    field :default_dose, :integer
  end
end
