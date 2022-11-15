defmodule Year18Day1 do
  def solve(input, 18_01_01) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def solve(input, 18_01_02) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Stream.cycle()
    |> reduce_until_repeated_twice
  end

  defp reduce_until_repeated_twice(changes) do
    Enum.reduce_while(changes, {0, MapSet.new()}, fn change, {last, visited} ->
      resulting_frequency = last + change

      if MapSet.member?(visited, resulting_frequency) do
        {:halt, resulting_frequency}
      else
        {:cont, {resulting_frequency, MapSet.put(visited, resulting_frequency)}}
      end
    end)
  end
end
