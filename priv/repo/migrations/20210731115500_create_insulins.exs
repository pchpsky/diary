defmodule Diary.Repo.Migrations.CreateInsulins do
  use Ecto.Migration

  def change do
    create table(:insulins) do
      add :name, :string
      add :color, :string

      timestamps()
    end
  end
end
