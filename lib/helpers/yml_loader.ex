# reads .yml files in the /priv dir

defmodule LaywisBot.Helpers.YamlLoader do
  require Logger

  def load_yaml(filename, app_name) do
    app_root_dir = Application.app_dir(app_name)
    file_path = Path.join([app_root_dir, "priv", filename])

    case File.read(file_path) do
      {:ok, content} ->
        case YamlElixir.read_from_string(content) do
          {:ok, data} ->
            data
          {:error, reason} ->
            Logger.error("couldnt load YAML data from: \"#{file_path}\": #{inspect(reason)}")
            []
        end
      {:error, reason} ->
        Logger.error("couldn't read file at: \"#{file_path}\": #{inspect(reason)}")
        []
    end
  end
end
