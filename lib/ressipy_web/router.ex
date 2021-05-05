defmodule RessipyWeb.Router do
  use RessipyWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RessipyWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RessipyWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live_dashboard "/dashboard", metrics: RessipyWeb.Telemetry
  end
end
