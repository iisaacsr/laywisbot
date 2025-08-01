defmodule LaywisBot.Commands.Voice.Play do
  require Logger

  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Voice

  def name(), do: "play"

  @impl true
  def description(), do: "plays a song (search or url)"

  @impl true
  def options(), do: [
    %{
      type: :string,
      name: "query",
      description: "url to the song or search parameters",
      required: true
    }
  ]

  @impl true
  def command(interaction) do
    guild_id = interaction.guild_id
    voice_channel_id = Helpers.VoiceHelpers.get_voice_channel_of_interaction(interaction)

    user_input = Enum.find_value(interaction.data.options, nil, fn
      %{name: "query", value: value} -> value # Now we look for 'query'
      _ -> nil
    end)

    if !Voice.ready?(guild_id) do
      Voice.join_channel(guild_id, voice_channel_id)

      # gamer move (what is async?)
      Process.sleep(1500)
    end

    song = Helpers.VoiceHelpers.parse_user_input(user_input)

    case song do
      {:ok, stream_url, song_title} ->
        if Voice.ready?(guild_id) do
          if stream_url do
            case Voice.play(guild_id, stream_url, :ytdl) do
              :ok ->
                [content: "playing: **#{song_title}**"]
              {:error, reason} ->
                Logger.error("couldn't play url #{stream_url} in guild #{guild_id}")
                [content: "couldn't play the song: #{inspect(reason)}"]
            end
          else
            [content: "couldn't find the song"]
          end
        else
          [content: "i'm not in a channel (use /join, bug)"]
        end

      {:error, message} ->
        [content: message]
    end
  end

  @impl true
  def type(), do: :slash
end
