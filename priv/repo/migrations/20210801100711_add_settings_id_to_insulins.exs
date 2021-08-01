defmodule Diary.Repo.Migrations.AddSettingsIdToInsulins do
  use Ecto.Migration

  def change do
    alter table(:insulins) do
      add :settings_id, references(:user_settings, on_delete: :delete_all), null: false
    end
  end
end
