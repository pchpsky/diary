defmodule DiaryWeb.Router do
  use DiaryWeb, :router

  import DiaryWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DiaryWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api_authenticated do
    plug DiaryWeb.AuthAccessPipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :title_screen do
    plug :put_layout, html: {DiaryWeb.Layouts, :title}
    plug :fetch_current_user
  end

  scope "/", DiaryWeb do
    pipe_through [:browser]

    live_session :default, on_mount: [DiaryWeb.UserAuthLive, DiaryWeb.LocalesLive, DiaryWeb.NavLive] do
      live "/home", HomeLive
      live "/settings", SettingsLive

      live "/insulin", InsulinLive
      live "/insulin/record", RecordInsulinLive
      live "/insulin/:id/edit", EditInsulinLive

      live "/glucose", GlucoseLive
      live "/glucose/record", RecordGlucoseLive
      live "/glucose/:id/edit", EditGlucoseLive
    end
  end

  scope "/", DiaryWeb do
    pipe_through [:browser, :title_screen]

    get "/", TitleController, :index
  end

  ## Authentication routes

  scope "/", DiaryWeb do
    pipe_through [:browser, :fetch_current_user, :redirect_if_user_is_authenticated, :title_screen]

    get "/sign_up", UserRegistrationController, :new
    post "/sign_up", UserRegistrationController, :create
    get "/sign_in", UserSessionController, :new
    post "/sign_in", UserSessionController, :create
  end

  scope "/", DiaryWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  scope "/api", DiaryWeb.Api do
    pipe_through :api

    post "/users", UserController, :create
    post "/sessions", SessionController, :create
    post "/telegram/:token", TelegramUpdatesController, :handle
  end

  pipeline :graphql do
    plug DiaryWeb.Schema.AuthContext
  end

  scope "/graph" do
    pipe_through :graphql

    forward "/", Absinthe.Plug, schema: DiaryWeb.Schema
  end

  forward "/graphiql", Absinthe.Plug.GraphiQL, schema: DiaryWeb.Schema

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: DiaryWeb.Telemetry
    end
  end
end
