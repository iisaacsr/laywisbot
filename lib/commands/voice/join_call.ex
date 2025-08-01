defmodule LaywisBot.Commands.Voice.JoinCall do
  require Logger
  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Voice

  def name(), do: "join"

  @impl true
  def description(), do: "Make Laywis join the call"

  @impl true
  def command(interaction) do
    guild_id = interaction.guild_id

    voice_channel_id = Helpers.VoiceHelpers.get_voice_channel_of_interaction(interaction)

    case voice_channel_id do
      nil ->
        [content: "join a channel bro"]
      channel_id ->
        Logger.info("joining channel: #{channel_id} in guild: #{guild_id}")

        case Voice.join_channel(guild_id, channel_id) do
          :ok ->
            [content: "Laywis is coming"]
        end
    end
  end

  @impl true
  def type(), do: :slash

end
