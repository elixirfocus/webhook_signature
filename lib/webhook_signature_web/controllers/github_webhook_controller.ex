defmodule WebhookSignatureWeb.GitHubWebhookController do
  use WebhookSignatureWeb, :controller

  def webhook(conn, _params) do
    json(conn, nil)
  end
end
