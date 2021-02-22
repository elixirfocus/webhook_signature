defmodule WebhookSignatureWeb.Router do
  use WebhookSignatureWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json],
      pass: ["*/*"],
      json_decoder: Phoenix.json_library()
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug WebhookSignatureWeb.Plugs.RawBodyPassthrough, length: 4_000_000

    # It is important that this comes after `WebhookSignatureWeb.Plugs.RawBodyPassthrough`
    # as it relies on the `:raw_body` being inside the `conn.assigns`.
    plug WebhookSignatureWeb.Plugs.RequirePayloadSignatureMatch
  end

  scope "/", WebhookSignatureWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/github", WebhookSignatureWeb do
    pipe_through :api

    post "/webhook", GitHubWebhookController, :webhook
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebhookSignatureWeb do
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
      live_dashboard "/dashboard", metrics: WebhookSignatureWeb.Telemetry
    end
  end
end
