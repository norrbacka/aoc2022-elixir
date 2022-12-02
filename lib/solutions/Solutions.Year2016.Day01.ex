defmodule Solutions.Year2016.Day01 do
  @moduledoc """
  Solutions for Year 2016 and Day 1
  """
  defmacro __using__(_opts) do
    quote do
      def solve(input, 16_01_01) do
        pos = %{x: 0, y: 0, dir: :north, history: []}

        input
        |> String.split(", ")
        |> Enum.map(fn x -> String.split_at(x, 1) end)
        |> Enum.map(fn [dir | steps] ->
          %{dir: dir, steps: steps}
        end)
      end

      def solve(input, 16_01_02) do
        input
      end
    end
  end
end
