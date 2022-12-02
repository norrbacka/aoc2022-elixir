defmodule Solutions.Year2016.Day01 do
  @moduledoc """
  Solutions for Year 2016 and Day 1
  """
  def rotate(:north, "R"), do: :east
  def rotate(:east, "R"), do: :south
  def rotate(:south, "R"), do: :west
  def rotate(:west, "R"), do: :north

  def rotate(:north, "L"), do: :west
  def rotate(:east, "L"), do: :north
  def rotate(:south, "L"), do: :east
  def rotate(:west, "L"), do: :south

  def traverse(inputs, pos) do
    if Enum.empty?(inputs) do
      pos
    else
      [%{dir: dir, steps: steps} | inputs] = inputs
      new_dir = rotate(pos.dir, dir)
      x = case new_dir do
        :west -> pos.x - steps
        :east -> pos.x + steps
        _ -> pos.x
      end
      y = case new_dir do
        :north -> pos.y - steps
        :south -> pos.y + steps
        _ -> pos.y
      end
      pos = %{
        x: x,
        y: y,
        dir: new_dir,
        history: pos.history ++ [steps]
      }
      traverse(inputs, pos)
    end
  end

  defmacro __using__(_opts) do
    quote do

      def solve(input, 16_01_01) do
        pos = %{x: 0, y: 0, dir: :north, history: []}

        inputs =
          input
          |> String.split(", ")
          |> Enum.map(fn x -> String.split_at(x, 1) end)
          |> Enum.map(fn {dir, steps} ->
            steps = String.to_integer(String.trim(steps))
            %{dir: dir, steps: steps}
          end)
        hq = Solutions.Year2016.Day01.traverse(inputs, pos)
        abs(hq.x) + abs(hq.y)
      end

      def solve(input, 16_01_02) do
        input
      end
    end
  end
end
