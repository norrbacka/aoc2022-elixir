defmodule Solutions.Year2018.Day01 do
  @moduledoc """
  Solutions for Year 2018 and Day 1
  """
  defmacro __using__(_opts) do
    quote do
      import Solutions.Year2018.Day01

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
    end
  end

  def reduce_until_repeated_twice(changes) do
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
