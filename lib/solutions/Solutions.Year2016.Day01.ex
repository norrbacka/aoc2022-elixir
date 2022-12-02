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

  def traverse(inputs, pos, all_pos \\ []) do
    if Enum.empty?(inputs) do
      [pos, all_pos]
    else
      [%{dir: dir, steps: steps} | inputs] = inputs
      new_dir = rotate(pos.dir, dir)

      x =
        case new_dir do
          :west -> pos.x - steps
          :east -> pos.x + steps
          _ -> pos.x
        end

      y =
        case new_dir do
          :north -> pos.y - steps
          :south -> pos.y + steps
          _ -> pos.y
        end

      history =
        case new_dir do
          :west ->
            range = Enum.to_list((pos.x - 1)..x)
            Enum.map(range, fn i -> [i, pos.y] end)

          :east ->
            range = Enum.to_list((pos.x + 1)..x)
            Enum.map(range, fn i -> [i, pos.y] end)

          :north ->
            range = Enum.to_list((pos.y - 1)..y)
            Enum.map(range, fn i -> [pos.x, i] end)

          :south ->
            range = Enum.to_list((pos.y + 1)..y)
            Enum.map(range, fn i -> [pos.x, i] end)
        end

      pos = %{
        x: x,
        y: y,
        dir: new_dir,
        history: pos.history ++ history
      }

      traverse(inputs, pos, all_pos ++ [pos])
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

        [hq, _] = Solutions.Year2016.Day01.traverse(inputs, pos)
        abs(hq.x) + abs(hq.y)
      end

      def solve(input, 16_01_02) do
        pos = %{x: 0, y: 0, dir: :north, history: []}

        inputs =
          input
          |> String.split(", ")
          |> Enum.map(fn x -> String.split_at(x, 1) end)
          |> Enum.map(fn {dir, steps} ->
            steps = String.to_integer(String.trim(steps))
            %{dir: dir, steps: steps}
          end)

        [hq, allpos] = Solutions.Year2016.Day01.traverse(inputs, pos)
        history = hq.history |> Enum.map(fn [x, y] -> %{x: x, y: y} end)

        index =
          Enum.map(history, fn x ->
            %{cords: x, dupe: Enum.count(history, fn y -> y == x end) == 2}
          end)

        index
        |> Enum.find(fn x -> x.dupe end)
        |> then(fn %{cords: cords, dupe: dupe} -> abs(cords.x) + abs(cords.y) end)
      end
    end
  end
end
