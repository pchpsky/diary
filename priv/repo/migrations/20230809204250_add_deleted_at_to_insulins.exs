defmodule Diary.Repo.Migrations.AddDeletedAtToInsulins do
  use Ecto.Migration

  def change do
    alter table(:insulins) do
      add :deleted_at, :naive_datetime
    end
  end
end
