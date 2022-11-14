defmodule Helpers do
  defp download(day, year \\ 2022) do
    IO.puts("Downloading data for year #{year} and day #{day}...")
    url = "https://adventofcode.com/#{year}/day/#{day}/input"
    user_cookie = [cookie: ["session=#{System.get_env("SESSION")}"]]
    response = HTTPoison.get(url, %{}, hackney: user_cookie)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found...")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  def get(day, year \\ 2022) do
    file_path = "./lib/inputs/#{year}_#{day}.txt"

    case File.exists?(file_path) do
      true ->
        File.read!(file_path)

      false ->
        content = download(day, year)

        Path.expand(file_path)
        |> Path.absname()
        |> File.write!(content, [:write])

        get(day, year)
    end
  end
end
