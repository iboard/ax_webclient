defmodule WebClientWeb.Router do
  use WebClientWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {WebClientWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WebClientWeb do
    pipe_through :browser

    # Posts
    get "/", BlogController, :index
    get "/tags/:tag", BlogController, :tags
    get "/posts/:id", BlogController, :read

    # Pages
    get "/pages", PageController, :index

    # Session
    get "/sign_in", SessionController, :new
    post "/sign_in", SessionController, :create
    get "/sign_out", SessionController, :delete
  end

  # Enables Phoenix.LiveDashboard in :dev and :test environment.
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WebClientWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
