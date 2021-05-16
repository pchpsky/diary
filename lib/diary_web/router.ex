defmodule DiaryWeb.Router do
  use DiaryWeb, :router

  import DiaryWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DiaryWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :title_screen do
    plug :put_layout, {DiaryWeb.LayoutView, "title.html"}
  end

  scope "/", DiaryWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/home", HomeController, :index

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", DiaryWeb do
    pipe_through [:browser, :title_screen]

    get "/", TitleController, :index
    live "/insulin", InsulinLive, :index
    # live "/", PageLive, :index
  end

  ## Authentication routes

  scope "/", DiaryWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated, :title_screen]

    get "/sign_up", UserRegistrationController, :new
    post "/sign_up", UserRegistrationController, :create
    get "/sign_in", UserSessionController, :new
    post "/sign_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", DiaryWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  # Other scopes may use custom stacks.
  # scope "/api", DiaryWeb do
  #   pipe_through :api
  # end

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
