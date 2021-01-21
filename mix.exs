defmodule Phoenix.GenSocketClient.Mixfile do
  use Mix.Project

  @version "3.3.0"
  @github_url "https://github.com/alboratech/phoenix_gen_socket_client"
  @original_github_url "https://github.com/Aircloak/phoenix_gen_socket_client"

  def project do
    [
      app: :phoenix_gen_socket_client,
      version: @version,
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),

      # Test
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        check: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Dialyzer
      dialyzer: dialyzer(),

      # Hex
      package: package(),
      description: "Socket client behaviour for phoenix channels.",

      # Docs
      docs: [
        source_url: @github_url,
        source_ref: "v#{@version}",
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [extra_applications: [:logger | extra_applications(Mix.env())]]
  end

  defp extra_applications(:prod), do: []
  defp extra_applications(_), do: [:websocket_client]

  defp deps do
    [
      {:websocket_client, "~> 1.2", optional: true},
      {:jason, "~> 1.2", optional: true},
      {:phoenix, "~> 1.5", only: :test},
      {:plug_cowboy, "~> 2.0", only: :test},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.13", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.23", only: [:dev, :test], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      check: [
        "compile --warnings-as-errors",
        "format --check-formatted",
        "credo --strict",
        "coveralls.html",
        "dialyzer --format short"
      ]
    ]
  end

  defp package do
    [
      name: :phx_gen_socket_client,
      maintainers: ["Albora"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @github_url,
        "Original GitHub" => @original_github_url,
        "Docs" => "http://hexdocs.pm/phx_gen_socket_client"
      }
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:mix, :ex_unit, :jason],
      plt_file: {:no_warn, "priv/plts/" <> plt_file_name()},
      flags: [
        :unmatched_returns,
        :error_handling,
        :race_conditions,
        :no_opaque,
        :unknown,
        :no_return
      ]
    ]
  end

  defp plt_file_name do
    "dialyzer-#{Mix.env()}-#{System.otp_release()}-#{System.version()}.plt"
  end
end
