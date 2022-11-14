defmodule Aoc22 do
  defp get(day, year \\ 2022) do
    url = "https://adventofcode.com/#{year}/day/#{day}/input"
    user_cookie = [cookie: ["session=#{System.get_env("SESSION")}"]]
    response = HTTPoison.get(url, %{}, hackney: user_cookie)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts(body)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found...")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  def hello do
    get(1, 2018)
  end
end
