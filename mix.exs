defmodule Elrondex.MixProject do
  use Mix.Project

  @source_url "https://github.com/elrondex/elrondex"
  @version "0.1.0"

  def project() do
    [
      app: :elrondex,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: @source_url,
      # Hex
      description: description(),
      package: package(),
      # Docs
      name: "Elrondex",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application() do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps() do
    [
      {:jason, "~> 1.2"},
      {:tesla, "~> 1.4"},
      {:mnemo, "~> 0.1.3"},
      {:bech32, "~> 1.0"}
    ]
  end

  defp description() do
    """
      Elixir library to interact with Elrond Blockchain and its components 
      $EGLD, Arwen, WASM, DeFI, SC, ESDTs, NFTs, SFTs, $MEX, DEX, AMM
    """
  end

  defp package() do
    [
      maintainers: ["Alchimiștii Elixir"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url, "Twitter" => "https://twitter.com/elrondex"},
      files: ~w(.formatter.exs mix.exs README.md lib test)
    ]
  end

  defp docs do
    [
      main: "Elrondex",
      canonical: "http://hexdocs.pm/elrondex",
      source_url: @source_url
    ]
  end
end
