defmodule Diary.Repo.Migrations.AddForeignKeysToInsulinMetrics do
  use Ecto.Migration

  def change do
    alter table(:insulin_metrics) do
      modify :insulin_id, references(:insulins, on_delete: :nothing)
    end
  end
end
