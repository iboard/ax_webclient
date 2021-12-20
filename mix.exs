defmodule WebClient.MixProject do
  use Mix.Project

  defp description() do
    ~s"""
    A simple Phoenix/Liveview client for [Altex](https://github.com/iboard/altex).
    Use it as a scaffold.
    """
  end

  defp package do
    [
      name: "ax_webclient",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Andreas Altendorfer"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/iboard/ax_webclient"}
    ]
  end

  def project do
    [
      app: :web_client,
      version: "0.1.1",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      xref: [exclude: [:crypto]],

      # Hex
      package: package(),
      description: description(),
      licenses: ["MIT"],
      links: ["https://github.com/iboard/altex"],

      # Docs
      name: "Altex.WebClient",
      source_url: "https://github.com/iboard/ax_webclient",
      homepage_url: "https://github.com/iboard/ax_webclient",
      docs: [
        # The main page in the docs
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {WebClient.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Phoenix and tools
      {:phoenix, "~> 1.6.4"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.5"},
      {:floki, ">= 0.30.0"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      # Blog
      {:nimble_publisher, "~> 0.1"},
      {:makeup_elixir, ">= 0.0.0"},
      {:makeup_erlang, ">= 0.0.0"},
      {:ex_doc, "~> 0.26", only: :dev, runtime: false},
      # Altex
      {:axrepo, "~> 0.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
