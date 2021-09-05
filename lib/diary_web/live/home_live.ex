defmodule DiaryWeb.HomeLive do
  @moduledoc false
  use DiaryWeb, :live_view

  @impl true
  def mount(_parms, _session, socket) do
    {:ok, assign(socket, page: :home)}
  end
end
