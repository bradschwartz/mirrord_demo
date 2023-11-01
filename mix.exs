defmodule MirrordDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :mirrord_demo,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MirrordDemo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.0"},
      {:plug_cowboy, "~> 2.1"},
      {:tesla, "~> 1.7"}
    ]
  end
end
