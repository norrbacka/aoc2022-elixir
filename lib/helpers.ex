defmodule Helpers do
  @moduledoc """
  Advent of code helper functions, like fetching input, submiting answers, and so forth.
  """
  def parse(year_day_level) do
    [year, day, level] =
      to_string(year_day_level)
      |> String.codepoints()
      |> Enum.chunk_every(2)
      |> Enum.map(&Enum.join/1)
      |> Enum.map(&String.to_integer/1)

    fixed_year = String.to_integer("20#{year}")

    [fixed_year, day, level]
  end

  def get_session, do: System.get_env("SESSION")

  defp download(year, day) do
    IO.puts("Downloading data for year #{year} and day #{day}...")
    url = "https://adventofcode.com/#{year}/day/#{day}/input"
    user_cookie = [cookie: ["session=#{get_session()}"]]
    response = HTTPoison.get(url, %{}, hackney: user_cookie)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found...")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts(reason)
    end
  end

  def get_input(year, day) do
    file_path = "./lib/inputs/#{year}_#{day}.txt"

    case File.exists?(file_path) do
      true ->
        File.read!(file_path)

      false ->
        content = download(year, day)

        Path.expand(file_path)
        |> Path.absname()
        |> File.write!(content, [:write])

        get_input(year, day)
    end
  end

  # Has some error text if parsing is added https://github.com/toblu/advent-of-code-client/blob/b1bcd5833353c6fce41d521737dce4e5ce6d53e0/src/util/api.ts#L114
  defp parse_nodes_to_text(nodes) do
    nodes
    |> Enum.map(fn node ->
      case node do
        {_, _, children_nodes} ->
          parse_nodes_to_text(children_nodes)

        text ->
          text
      end
    end)
    |> List.flatten()
    |> Enum.join(" ")
  end

  def post_answer(year, day, level, answer) do
    url = "https://adventofcode.com/#{year}/day/#{day}/answer"

    payload =
      %{
        "answer" => answer,
        "level" => level
      }
      |> URI.encode_query()

    headers = %{
      "User-Agent" =>
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36",
      "cache-control" => "no-cache",
      "Content-Type" => "application/x-www-form-urlencoded"
    }

    options = [
      follow_redirect: true,
      hackney: [
        {:force_redirect, true},
        {:cookie, ["session=#{get_session()}"]}
      ]
    ]

    %HTTPoison.Response{body: body} = HTTPoison.post!(url, payload, headers, options)
    p = Floki.find(body, "main article p")
    {_, _, children_nodes} = Enum.at(p, 0)
    text = parse_nodes_to_text(children_nodes)
    text
  end
end
