defmodule Diary.Repo.Migrations.CreateUserSettings do
  use Ecto.Migration

  def change do
    create table(:user_settings) do
      add :blood_glucose_units, :integer, default: 0
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:user_settings, :user_id)
  end
end
