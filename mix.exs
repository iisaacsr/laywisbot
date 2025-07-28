defmodule LaywisBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :laywisbot,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {LaywisBot.Application, []},
      included_applications: [:nostrum],
      extra_applications: [:certifi, :gun, :inets, :jason, :mime, :logger, :runtime_tools],
    ]
  end

  defp deps do
    [
      {:nostrum, "~> 0.10", runtime: false}
    ]
  end

end
