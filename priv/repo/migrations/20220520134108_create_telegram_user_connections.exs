defmodule Diary.Repo.Migrations.CreateTelegramUserConnections do
  use Ecto.Migration

  def change do
    create table(:telegram_user_connections) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :chat_id, :integer

      timestamps()
    end

    create unique_index(:telegram_user_connections, [:user_id])
  end
end
