defmodule LaywisBot.Commands.Voice.JoinCall do
  require Logger
  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Voice
  alias Nostrum.Cache.GuildCache

  def name(), do: "join"

  @impl true
  def description(), do: "Make Laywis join the call"

  @impl true
  def command(interaction) do
    guild_id = interaction.guild_id

    voice_channel_id = get_voice_channel_of_interaction(interaction)

    case voice_channel_id do
      nil ->
        [content: "join a channel bro"]
      channel_id ->
        Logger.info("joining channel: #{channel_id} in guild: #{guild_id}")

        case Voice.join_channel(guild_id, channel_id) do
          :ok ->
            [content: "Laywis is coming"]
          {:error} ->
            [content: "couldnt join the channel #{channel_id}"]
        end
    end
  end

  @impl true
  def type(), do: :slash

  defp get_voice_channel_of_interaction(%{guild_id: guild_id, user: %{id: user_id}} = _interaction) do
    guild_id
    |> GuildCache.get!()
    |> Map.get(:voice_states)
    |> Enum.find(%{}, fn v -> v.user_id == user_id end)
    |> Map.get(:channel_id)
  end
end
