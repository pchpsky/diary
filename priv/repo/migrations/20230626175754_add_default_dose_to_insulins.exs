defmodule Diary.Repo.Migrations.AddDefaultDoseToInsulins do
  use Ecto.Migration

  def change do
    alter table(:insulins) do
      add :default_dose, :integer
    end
  end
end
