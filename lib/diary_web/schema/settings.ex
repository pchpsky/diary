defmodule DiaryWeb.Schema.Settings do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias DiaryWeb.Resolvers.Settings, as: SettingsResolvers

  @desc "User settings"
  object :settings do
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
      resolve(fn _, _, _ -> Result.ok(%{}) end)
    end
  end
end
