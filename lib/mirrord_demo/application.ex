defmodule MirrordDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  alias Mirrord.SimplePlugRest

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: MirrordDemo.Worker.start_link(arg)
      # {MirrordDemo.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: SimplePlugRest, options: [port: 8080]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MirrordDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
