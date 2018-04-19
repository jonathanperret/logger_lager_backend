defmodule LoggerLagerBackend.Mixfile do
  use Mix.Project

  def project do
    [app: :logger_lager_backend,
     description: "A Logger backend that forwards messages to lager",
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     deps: deps()]
  end

  defp package do
    [maintainers: ["Jonathan Perret"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/jonathanperret/logger_lager_backend"},
     files: ["lib", "mix.exs", "README.md", "LICENSE"]]
  end

  def application do
    [applications: [:lager, :logger]]
  end

  defp deps do
    [
      {:lager, "~> 3.6.1"},
    ]
  end
end
