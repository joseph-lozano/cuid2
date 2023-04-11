defmodule Cuid2.MixProject do
  use Mix.Project

  def project do
    [
      app: :cuid2,
      version: "0.0.1",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "cuid2",
      package: [
        licenses: ["MIT"],
        links: ["https://github.com/joseph-lozano/cuid2"],
        source_url: "https://github.com/joseph-lozano/cuid2"
      ],
      description: """
      An Elixir implementation of cuid2

      See https://github.com/paralleldrive/cuid2
      """
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
