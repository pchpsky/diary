defmodule Diary.Repo.Migrations.CreateGlucoseMetrics do
  use Ecto.Migration

  def change do
    create table(:glucose_metrics) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :units, :float
      add :status, :integer, default: 0
      add :notes, :text
      add :measured_at, :naive_datetime

      timestamps()
    end
  end
end
