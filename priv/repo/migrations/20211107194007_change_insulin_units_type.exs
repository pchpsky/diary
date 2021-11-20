defmodule Diary.Repo.Migrations.ChangeInsulinUnitsType do
  use Ecto.Migration

  def change do
    alter table(:insulin_metrics) do
      modify :units, :float, from: :integer
    end
  end
end
