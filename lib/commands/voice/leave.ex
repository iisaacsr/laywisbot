defmodule LaywisBot.Commands.Voice.Leave do
  require Logger
  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Voice

  def name(), do: "leave"

  @impl true
  def description(), do: "Laywis begone"

  @impl true
  def command(interaction) do
    guild_id = interaction.guild_id

    if Voice.ready?(guild_id) do
      if Voice.playing?(guild_id) do
        Voice.stop(guild_id)
      end
      Voice.leave_channel(guild_id)
      [content: "leaving channel..."]
    else
      [content: "not in a channel"]
    end
  end

  @impl true
  def type(), do: :slash
end
