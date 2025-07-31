# see (https://github.com/kshannoninnes/sample_bot), pretty much a copy

defmodule LaywisBot.CommandLoader do
  require Logger

  alias Nosedrum.Storage.Dispatcher

    def load_all() do
    all_modules = get_all_command_modules()

    application_commands = filter_application_commands(all_modules)

    queue_commands(application_commands)

    configured_guild_ids = Application.get_env(:laywisbot, :guild_ids)

    configured_guild_ids
    |> register_commands()

  end

  defp get_all_command_modules() do
    # See: https://www.erlang.org/doc/man/code#all_available-0
    :code.all_available()
    |> Enum.filter(fn {module, _, _} -> is_command?(module) end)
    |> Enum.map(fn {module_charlist, _, _} -> List.to_existing_atom(module_charlist) end)
  end

  defp is_command?(module_charlist) do
    module_string = List.to_string(module_charlist)
    is_match = String.starts_with?(module_string, "Elixir.LaywisBot.Commands")
    is_match
  end

  # filter out any module that doesn't implement the ApplicationCommand behaviour
  defp filter_application_commands(command_list) do
    Enum.filter(command_list, fn command ->
      case command.module_info(:attributes)[:behaviour] do
        attr when is_list(attr) -> Enum.member?(attr, Nosedrum.ApplicationCommand)
        nil -> false
      end
    end)
  end

  defp queue_commands(commands) do
    Enum.each(commands, fn command ->
      Dispatcher.queue_command(command.name(), command)
      Logger.debug("added module #{command} as command /#{command.name()}")
    end)
  end

  defp register_commands([]), do: register_commands_with(:global)

  defp register_commands(server_list) do
    Enum.each(server_list, fn server_id ->
      register_commands_with(server_id)
    end)
  end

  defp register_commands_with(server_id) do
    case Dispatcher.process_queue(server_id) do
      {:error, {:error, error}} ->
        Logger.error("error processing commands for server #{server_id}:\n #{inspect(error, pretty: true)}")
      {:ok} ->
        Logger.debug("registered commands to #{server_id}")
      _other_return ->
        Logger.warning("returned unhandled error durring command registration")
    end
  end
end
