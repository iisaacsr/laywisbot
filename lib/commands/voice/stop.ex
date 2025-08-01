defmodule LaywisBot.Commands.Voice.Stop do
  require Logger

  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Voice

  def name(), do: "stop"

  @impl true
  def description(), do: "shut up Laywis"

  @impl true
  def command(interaction) do
    guild_id = interaction.guild_id

    if !Voice.playing?(guild_id) do
      [content: "i'm not playing a song bro"]
    else
      Voice.stop(guild_id)
      [content: "stopping playing music"]
    end
  end

  @impl true
  def type(), do: :slash
end
