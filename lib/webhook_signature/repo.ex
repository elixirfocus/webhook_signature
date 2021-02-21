defmodule WebhookSignature.Repo do
  use Ecto.Repo,
    otp_app: :webhook_signature,
    adapter: Ecto.Adapters.Postgres
end
