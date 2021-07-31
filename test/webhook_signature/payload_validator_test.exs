defmodule WebhookSignature.PayloadValidatorTest do
  use ExUnit.Case

  alias WebhookSignature.PayloadValidator
  alias Plug.Conn

  describe "is_authentic_payload?/2" do
    setup do
      # `is_authentic_payload?/2` relies on an application configuration of
      # `webhook_secret` and thus we need to prepare that application state
      # before each test.
      :ok = Application.put_env(:webhook_signature, :github, webhook_secret: "secretstuff")

      on_exit(fn ->
        :ok = Application.put_env(:webhook_signature, :github, webhook_secret: nil)
      end)
    end

    test "returns true when header signature matches payload" do
      payload = ~s({"hello":"world"})

      conn = %Conn{
        req_headers: [{"x-hub-signature", "sha1=b1f6e75cbe929a8b68c1f77b6fb87d6c4bc27cc9"}]
      }

      assert PayloadValidator.is_authentic_payload?(conn, payload)
    end

    test "returns false when header signature does not match payload" do
      payload = ~s({"hello":"world"})

      conn = %Conn{
        req_headers: [{"x-hub-signature", "sha1=BOGUS33+nZCLDWT6sg+LMELxmyG7Qv+0PkOFJYCTSXU="}]
      }

      refute PayloadValidator.is_authentic_payload?(conn, payload)
    end

    test "returns false when header signature is missing" do
      payload = ~s({"hello":"world"})

      conn = %Conn{
        req_headers: []
      }

      refute PayloadValidator.is_authentic_payload?(conn, payload)
    end
  end

  describe "generate_payload_signature/2" do
    test "can successfully generate payload signature" do
      payload = ~s({"hello":"world"})
      app_secret = "secretstuff"

      assert {:ok, "b1f6e75cbe929a8b68c1f77b6fb87d6c4bc27cc9"} =
               PayloadValidator.generate_payload_signature(payload, app_secret)
    end

    test "fails to generate payload signature when webhook_secret is missing" do
      payload = ~s({"hello":"world"})
      app_secret = nil

      assert {:error, :missing_app_secret} =
               PayloadValidator.generate_payload_signature(payload, app_secret)
    end
  end
end
