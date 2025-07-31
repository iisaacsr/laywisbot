defmodule LaywisBot.Application do
  use Application
  require Logger

  def start(_type, _args) do

    base_children = [
      Nosedrum.Storage.Dispatcher
    ]

    bot_options = %{
      name: LaywisBot,
      consumer: LaywisBot.CommandHandler,
      intents: [:guilds, :guild_messages, :guild_voice_states, :message_content],
      # exact path to the yt-dlp.exe file (can remove and use base path if wanted)
      youtubedl: System.get_env("YTDLP_PATH"),
      # ffmpeg.exe
      ffmpeg: System.get_env("FFMPEG_PATH"),
      wrapped_token: fn -> Application.fetch_env!(:laywisbot, :token) end
    }

    children = base_children ++ [{Nostrum.Bot, bot_options}]

    opts = [strategy: :one_for_one, name: LaywisBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
