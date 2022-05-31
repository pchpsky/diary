defmodule Diary.Telegram.UserConnection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "telegram_user_connections" do
    field :chat_id, :integer
    belongs_to :user, Diary.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(user_connection, attrs) do
    user_connection
    |> cast(attrs, [:user_id, :chat_id])
    |> validate_required([:user_id, :chat_id])
    |> unique_constraint(:user_id)
  end
end
