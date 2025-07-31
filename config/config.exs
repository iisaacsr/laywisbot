import Config

  config :laywisbot,
  guild_ids: [
    "499388437053308930",
    "573546089375072258"
  ],
  token: System.get_env("LAYWISBOT_TOKEN") || "none"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  level: :debug
