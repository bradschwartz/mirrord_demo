defmodule Mirrord.SimplePlugRest do
  @moduledoc """
  A Plug that always responds with a string
  """
  import Plug.Conn
  use Tesla
  require Logger

  @spec init(any()) :: any()
  def init(options) do
    options
  end

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _opts) do
    case conn.request_path do
      "/external" ->
        Logger.info("Making external request")
        {:ok, response} = Tesla.get("https://example.com")

        Logger.info("Response: #{inspect(response)}")

        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, "Call to #{response.url} returned #{response.status}")
        |> halt()

      "/internal" ->
        Logger.info("Making internal (pod) request")
        {:ok, response} = Tesla.get("http://nginx")

        Logger.info("Response: #{inspect(response)}")

        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, "Call to #{response.url} returned #{response.status}")
        |> halt()

      _ ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, "Hello world")
    end
  rescue
    e ->
      Logger.error("Error: #{inspect(e)}")

      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(500, "Error: #{inspect(e)}")
  end
end
