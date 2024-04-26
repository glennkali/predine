defmodule FineTuner.MixProject do
  use Mix.Project

  def project do
    [
      app: :fine_tuner,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {FineTuner.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Bumblebee and friends
      {:bumblebee, "~> 0.5.3"},
      {:nx, "~> 0.7.0", override: true},
      {:exla, "~> 0.7.0"},
      {:axon, "~> 0.6.1"},
      {:explorer, "~> 0.8.2"},
      # Scholar and friends
      {:scholar, "~> 0.2.0"},
      {:req, "~> 0.3.9"},
      {:vega_lite, "~> 0.1.9"},
      {:kino_vega_lite, "~> 0.1.9"},
      {:kino, "~> 0.10.0"},
      {:kino_explorer, "~> 0.1.7"},
      {:adbc, "~>0.1"},
    ]
  end
end
