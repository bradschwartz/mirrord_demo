defmodule Mirrord.SimplePlugRest do
  @moduledoc """
  A Plug that always responds with a string
  """
  import Plug.Conn
  use Tesla
  require Logger

  def init(options) do
    options
  end

  @doc """
  Simple route that returns a string
  """
  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _opts) do
    if conn.request_path == "/external" do
      Logger.info("Making external request")
      {:ok, response} = Tesla.get("https://example.com")

      Logger.info("Response: #{inspect(response)}")

      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(200, "Call to #{response.url} returned #{response.status}")
      |> halt()
    else
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
