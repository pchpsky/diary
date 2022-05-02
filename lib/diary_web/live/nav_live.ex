defmodule DiaryWeb.NavLive do
  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    {:cont, socket |> assign(:breadcrumbs, [:home | current_breadcrumbs(socket)])}
  end

  defp current_breadcrumbs(socket) do
    case socket.view do
      DiaryWeb.SettingsLive -> [:settings]
      DiaryWeb.InsulinLive -> [:insulin]
      DiaryWeb.RecordInsulinLive -> [:insulin, :record]
      DiaryWeb.EditInsulinLive -> [:insulin, :edit]
      DiaryWeb.GlucoseLive -> [:glucose]
      DiaryWeb.RecordGlucoseLive -> [:glucose, :record]
      DiaryWeb.EditGlucoseLive -> [:glucose, :edit]
      _ -> []
    end
  end
end
