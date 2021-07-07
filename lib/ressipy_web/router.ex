defmodule RessipyWeb.Router do
  use RessipyWeb, :router

  import RessipyWeb.UserAuth
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RessipyWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Application.get_env(:ressipy, :include_sent_email_route?, false) do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  scope "/", RessipyWeb do
    pipe_through [:browser, :require_admin]

    # live "/", PageLive, :index
    live_dashboard "/dashboard", metrics: RessipyWeb.Telemetry
  end

  ## Recipe routes

  scope "/", RessipyWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/categories/new", CategoryController, :new

    post "/categories", CategoryController, :create
  end

  scope "/", RessipyWeb do
    pipe_through :browser

    get "/", CategoryController, :index
    get "/categories/:slug", CategoryController, :show
    get "/recipes/:slug", RecipeController, :show
  end

  ## API routes

  scope "/api", RessipyWeb.Api do
    pipe_through [:api]

    get "/categories", CategoryController, :index
    get "/categories/:slug", CategoryController, :show

    get "/recipes/:slug", RecipeController, :show
  end

  ## Authentication routes

  scope "/", RessipyWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", RessipyWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", RessipyWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
