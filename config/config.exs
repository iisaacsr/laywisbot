import Config

config :nostrum,
 token: "(token)",
 consumers: [LaywisBot.Consumer],
 intents: [:direct_messages, :guild_messages, :message_content]
