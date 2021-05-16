defmodule Diary.Repo.Migrations.CreateInsulinMetrics do
  use Ecto.Migration

  def change do
    create table(:insulin_metrics) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :units, :integer
      add :medication_id, :integer
      add :taken_at, :naive_datetime
      add :notes, :text

      timestamps()
    end
  end
end
