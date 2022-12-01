defmodule Solutions.Year2022.Day01 do
  @moduledoc """
  Solutions for Year 2022 and Day 1
  """
  defmacro __using__(_opts) do
    quote do
      def solve(input, 22_01_01) do
        calorie_counting(input)
        |> Enum.max()
      end

      def solve(input, 22_01_02) do
        calorie_counting(input)
        |> Enum.with_index()
        |> Enum.sort_by(fn {calories, index} -> calories end, :desc)
        |> Enum.take(3)
        |> Enum.map(fn {calories, index} -> calories end)
        |> Enum.sum()
      end

      defp calorie_counting(input) do
        input
        |> String.split("\n")
        |> Enum.chunk_by(&(&1 == ""))
        |> Enum.filter(fn x -> Enum.any?(x, fn y -> y == "" end) == false end)
        |> Enum.map(fn x -> Enum.map(x, fn y -> String.to_integer(y) end) |> Enum.sum() end)
      end
    end
  end
end
