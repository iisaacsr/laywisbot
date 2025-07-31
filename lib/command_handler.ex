defmodule LaywisBot.CommandHandler do
  @behaviour Nostrum.Consumer
  require Logger

  alias LaywisBot.CommandLoader
  alias Nosedrum.Storage.Dispatcher
  alias Nostrum.Struct.WSState
  alias Nostrum.Struct.Message
  alias Nostrum.Struct.VoiceState
  alias Nostrum.Struct.Event.SpeakingUpdate

  #todo : switch to case block instead maybe?

  def handle_event({:READY, _, _}), do: CommandLoader.load_all()
  def handle_event({:INTERACTION_CREATE, intr, _}), do: Dispatcher.handle_interaction(intr)
  def handle_event({:MESSAGE_CREATE, %Message{content: content, guild_id: guild_id}, _ws_state}), do: Logger.info("sent message \"#{content}\" on guild #{guild_id}")
  def handle_event({:VOICE_STATE_UPDATE, %VoiceState{guild_id: guild_id}}), do: Logger.info("changed my voice state in guild #{guild_id}")
  def handle_event({:VOICE_SPEAKING_UPDATE, %SpeakingUpdate{guild_id: guild_id, speaking: speaking}, _voice_ws_state}) do
    speaking_status = if speaking, do: "started speaking", else: "stopped speaking"
    Logger.info"#{speaking_status} in guild #{guild_id}"
  end
  def handle_event({:RESUMED, _, %WSState{gateway: gateway, session: session}}), do: Logger.info("resumed session #{session} on gateway #{gateway}")
  def handle_event({atom_name, _payload, _ws_state}), do: Logger.warning("received unhandled event of type: #{atom_name}")
  # double catch, just in case (switch one another if need of more detail)
  def handle_event(other_event), do: Logger.warning("received unhandled event of type: #{inspect(other_event)}")
end
