defmodule LaywisBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :laywisbot,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {LaywisBot.Application, []},
      extra_applications: [:logger],
    ]
  end

  defp deps do
    [
      {:nostrum, git: "https://github.com/iisaacsr/nostrum", override: true},
      {:nosedrum, git: "https://github.com/jchristgit/nosedrum"},
      {:yaml_elixir, "~> 2.0"}
    ]
  end
end
