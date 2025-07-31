defmodule LaywisBot.Commands.Voice.Play do
  require Logger
  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Voice

  def name(), do: "play"

  @impl true
  def description(), do: "play music"

  @impl true
  def options(), do: [
    %{
      type: :sub_command,
      name: "song",
      description: "play a default song (search)"
    },
    %{
      type: :sub_command,
      name: "url",
      description: "play url from a website (youtube, soundcloud)",
      options: [
        %{
          type: :string,
          name: "url",
          description: "url to the song",
          required: true
        }
      ]
    }
  ]

  @soundcloud_url "https://soundcloud.com/fyre-brand/level-up"

  @impl true
  def command(interaction) do
    guild_id = interaction.guild_id

    subcommand_data = List.first(interaction.data.options)

    if Voice.ready?(guild_id) do
      case subcommand_data.name do
        "song" ->
          Logger.info("Playing default Soundcloud song in guild #{guild_id}")
          Voice.play(guild_id, @soundcloud_url, :ytdl)
          [content: "playing song..."]
        "url" ->
          # Extract the URL from the nested options
          Voice.stop(guild_id)
          play_url = List.first(subcommand_data.options).value
          Logger.info("Playing URL: #{play_url} in guild #{guild_id} with ytdl")
          Voice.play(guild_id, play_url, :ytdl, realtime: true)
          [content: "playing song from url..."]
        _ ->
          Logger.warning("unknown subcommand: #{inspect(subcommand_data.name)}")
          [content: "(url) only works right now"]
      end
    else
      [content: "use /join first (for now)"]
    end
  end

  @impl true
  def type(), do: :slash
end
