defmodule Elrondex.MixProject do
  use Mix.Project

  def project do
    [
      app: :elrondex,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:tesla, "~> 1.4"},
      {:mnemo, "~> 0.1.3"},
      {:bech32, "~> 1.0"}

      # block_keys don't compile on windows
      # {:block_keys, "~> 0.1.10"}

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
