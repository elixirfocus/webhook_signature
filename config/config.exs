# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :webhook_signature,
  ecto_repos: [WebhookSignature.Repo]

# Configures the endpoint
config :webhook_signature, WebhookSignatureWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6GIdfVJV2HYMieWU9uQ6bZbVOUNVrVu8x1deQCr1PY66Pq7ZTkv14vjv7SWwiKjR",
  render_errors: [view: WebhookSignatureWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: WebhookSignature.PubSub,
  live_view: [signing_salt: "4lidY2FA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
