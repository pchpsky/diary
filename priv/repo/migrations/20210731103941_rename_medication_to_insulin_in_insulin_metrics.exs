defmodule Diary.Repo.Migrations.RenameMedicationToInsulinInInsulinMetrics do
  use Ecto.Migration

  def change do
    rename table(:insulin_metrics), :medication_id, to: :insulin_id
  end
end
