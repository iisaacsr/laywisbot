defmodule LaywisBot.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Nostrum.Application
    ]

    opts = [strategy: :one_for_one, name: Laywisbot.Sup]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def stop(_state) do
    :ok
  end
end
