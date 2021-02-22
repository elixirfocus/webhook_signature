defmodule WebhookSignatureWeb.Plugs.RawBodyPassthrough do
  @moduledoc """
  This plug will read the body for `POST` and PUT` request and store it into a
  new assigns key `:raw_body`.

  This plug is used on certain routes in preference to the default Phoenix
  behaviors that would automatically decode the params and request body into
  native elixir values for a controller. It is a required choice since the body
  of a `Plug.Conn` can only be read from once.
  """

  import Plug.Conn
  alias Plug.Conn

  @spec init(Keyword.t()) :: Keyword.t()
  def init(options), do: options

  @spec call(Conn.t(), term()) :: Conn.t()
  def call(%Conn{method: method} = conn, opts) when method == "POST" or method == "PUT" do
    case Conn.read_body(conn, opts) do
      {:ok, body, _conn_details} ->
        Conn.assign(conn, :raw_body, body)

      {:more, _partial_body, _conn_details} ->
        conn
        |> send_resp(413, "PAYLOAD TOO LARGE")
        |> halt
    end
  end

  def call(conn, _opts), do: Conn.assign(conn, :cached_body, %{})
end
