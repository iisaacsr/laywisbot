defmodule Helpers.VoiceHelpers do
  require Logger
  require Jason

  alias Nostrum.Cache.GuildCache

  def get_voice_channel_of_interaction(%{guild_id: guild_id, user: %{id: user_id}} = _interaction) do
    guild_id
    |> GuildCache.get!()
    |> Map.get(:voice_states)
    |> Enum.find(%{}, fn v -> v.user_id == user_id end)
    |> Map.get(:channel_id)
  end

  def parse_user_input(user_input) do
    is_url = String.starts_with?(user_input, "http://") || String.starts_with?(user_input, "https://")

    if is_url do
      case URI.parse(user_input) do
        %URI{host: host} = uri ->
          if String.contains?(host, "youtube.com") || String.contains?(host, "youtu.be") do
            cleaned_url = remove_youtube_queries(uri)
            {:ok, cleaned_url, cleaned_url}
          else
            {:ok, user_input, user_input}
          end
      end
    else
      search_youtube(user_input)
    end
  end

  # because of trash youtube update
  defp remove_youtube_queries(uri) do
    %URI{path: path, query: query} = uri

    video_id =
      cond do
        path && String.length(path) > 1 && String.length(String.trim_leading(path, "/")) == 11 ->
          String.trim_leading(path, "/")
        query ->
          URI.decode_query(query)["v"]
        true ->
          nil
      end

    if video_id do
      "https://www.youtube.com/watch?v=#{video_id}"
    else
      %{uri | query: nil, fragment: nil} |> URI.to_string()
    end
  end

  # searches youtube using yt-dlp and returns a url
  defp search_youtube(query) do
    Logger.info("searching youtube for #{query}")

    command = "yt-dlp"
    args = ["--no-config", "--default-search", "ytsearch", "-f", "bestaudio", "--print-json", query]

    case System.cmd(command, args, into: "") do
      {json_output, 0} -> # success
        case Jason.decode(json_output) do
          {:ok, %{"url" => stream_url, "title" => title}} ->
            Logger.info("yt-dlp found '#{title}' for query '#{query}'.")
            Logger.info(stream_url)
            {:ok, stream_url, title}
          {:ok, _} ->
            Logger.warning("no 'url' or 'title' from yt-dlp search. output: #{json_output}")
            {:error, "couldn't find the song from #{query} (skill issue)"}
          {:error, _} = json_decode_error ->
            Logger.error("couldn't parse json from '#{query}': #{inspect(json_decode_error)}. output: #{json_output}")
            {:error, "json parsing error, ise check logs"}
        end
      {error_output, _exit_code} ->
        Logger.error("couldn't play song from #{query}, output: #{error_output}")
        if String.contains?(error_output, "ERROR: No appropriate format found") do
          {:error, "found result for #{query}, but couldn't play"}
        else
          {:error, "unhandled search error"}
        end
    end
  end

end
