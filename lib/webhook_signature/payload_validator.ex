defmodule WebhookSignature.PayloadValidator do
  alias Plug.Conn

  def is_authentic_payload?(%Conn{req_headers: req_headers}, payload) do
    case signature_from_req_headers(req_headers) do
      nil ->
        false

      signature ->
        is_payload_signature_valid?(signature, payload)
    end
  end

  defp signature_from_req_headers(req_headers) do
    case List.keyfind(req_headers, "x-hub-signature", 0) do
      {"x-hub-signature", full_signature} ->
        "sha256=" <> signature = full_signature
        signature

      _ ->
        nil
    end
  end

  defp is_payload_signature_valid?(payload_signature, payload) do
    case generate_payload_signature(payload, webhook_secret()) do
      {:ok, generated_payload_signature} ->
        Plug.Crypto.secure_compare(generated_payload_signature, payload_signature)

      _ ->
        false
    end
  end

  def generate_payload_signature(_, nil) do
    {:error, :missing_app_secret}
  end

  def generate_payload_signature(payload, app_secret) do
    {:ok, :crypto.mac(:hmac, :sha256, app_secret, payload) |> Base.encode16(case: :lower)}
  end

  defp webhook_secret do
    Keyword.fetch!(Application.fetch_env!(:webhook_signature, :github), :webhook_secret)
  end
end
