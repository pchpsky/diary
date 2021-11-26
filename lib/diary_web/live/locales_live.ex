defmodule DiaryWeb.LocalesLive do
  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    case get_connect_params(socket) do
      %{"timezone" => tz} ->
        {:cont, assign(socket, timezone: tz)}

      _ ->
        {:cont, socket}
    end
  end
end