defmodule WebhookSignatureWeb.PageController do
  use WebhookSignatureWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
