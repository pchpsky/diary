defmodule DiaryWeb.LocalesLive do
  import Phoenix.LiveView
  import Phoenix.Component

  def on_mount(:default, _params, _session, socket) do
    tz = get_connect_params(socket)["timezone"] || "UTC"

    {:cont, assign(socket, tz: tz)}
  end
end
