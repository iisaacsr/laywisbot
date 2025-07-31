defmodule LaywisBot.Commands.Random.Wisdom do
  require Logger
  @behaviour Nosedrum.ApplicationCommand

  def name(), do: "wisdom"

  @impl true
  def description(), do: "Seek the wisdom of Laywis"

  @impl true
  def command(_interaction) do
    responses = LaywisBot.Helpers.YamlLoader.load_yaml("wisdom.yml", :laywisbot)

    if !Enum.empty?(responses) do
      [content: Enum.random(responses)]
    else
      [content: "Laywis has no more wisdom. (empty file?)"]
    end
  end

  @impl true
  def type(), do: :slash
end
