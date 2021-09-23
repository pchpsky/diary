defmodule DiaryWeb.Toast do
  def push(socket, message) do
    Phoenix.PubSub.broadcast!(
      Diary.PubSub,
      "toasts" <> inspect(socket.root_pid),
      {:make_toast, message}
    )
  end
end
