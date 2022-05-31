defmodule Diary.TelegramTest do
  use Diary.DataCase

  setup do
    %{user: Diary.AccountsFixtures.user_fixture()}
  end

  describe "connect/2" do
    test "connects user in chat", %{user: user} do
      assert {:ok, %Diary.Telegram.UserConnection{}} = Diary.Telegram.connect(user.id, 1)
    end

    test "ok if user is already connected to given chat", %{user: user} do
      assert {:ok, %Diary.Telegram.UserConnection{}} = Diary.Telegram.connect(user.id, 1)
      assert {:ok, %Diary.Telegram.UserConnection{}} = Diary.Telegram.connect(user.id, 1)
    end

    test "fails to connect if user connected to different chat", %{user: user} do
      assert {:ok, %Diary.Telegram.UserConnection{}} = Diary.Telegram.connect(user.id, 1)

      assert {:error, :already_connected} = Diary.Telegram.connect(user.id, 2)
    end

    test "connects user if another user connected to given chat", %{user: %{id: user_id}} do
      %{id: another_user_id} = Diary.AccountsFixtures.user_fixture()

      assert {:ok, %Diary.Telegram.UserConnection{user_id: ^another_user_id}} =
               Diary.Telegram.connect(another_user_id, 1)

      assert {:ok, %Diary.Telegram.UserConnection{user_id: ^user_id}} = Diary.Telegram.connect(user_id, 1)
    end
  end
end
