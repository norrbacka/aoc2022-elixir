defmodule Solutions.Year2022.Day03 do
  @moduledoc """
  Solutions for Year 2022 and Day 3
  """
  alias String.Unicode

  defmacro __using__(_opts) do
    quote do
      def solve(input, 22_03_01) do
        rucksacks =
          input
          |> String.split("\n", trim: true)
          |> Enum.map(fn row ->
            i = div(String.length(row), 2)

            [
              String.slice(row, 0..(i - 1))
              |> String.codepoints(),
              String.slice(row, i..-1//1)
              |> String.codepoints()
            ]
          end)

        rucksacks_shared_item =
          rucksacks
          |> Enum.map(fn [first, second] ->
            MapSet.intersection(MapSet.new(first), MapSet.new(second))
            |> MapSet.to_list()
            |> Enum.at(0)
          end)

        RucksackReorganization.count_points(rucksacks_shared_item)
      end

      def solve(input, 22_03_02) do
        rucksacks =
          input
          |> String.split("\n", trim: true)
          |> Enum.chunk_every(3)
          |> Enum.map(fn x -> Enum.map(x, fn y -> String.codepoints(y) end) end)

        rucksacks_shared_item =
          rucksacks
          |> Enum.map(fn [first, second, third] ->
            [MapSet.new(first), MapSet.new(second), MapSet.new(third)]
            |> Enum.reduce(fn m1, m2 -> MapSet.intersection(m1, m2) end)
            |> MapSet.to_list()
            |> Enum.at(0)
          end)

        RucksackReorganization.count_points(rucksacks_shared_item)
      end
    end
  end
end

defmodule RucksackReorganization do
  @moduledoc """
  RucksackReorganization logic
  """
  def count_points(rucksacks_shared_item) do
    lowercases =
      for i <- 97..122 do
        <<i::utf8>>
      end
      |> Enum.with_index()
      |> Enum.map(fn {l, i} -> %{l => i + 1} end)
      |> Enum.reduce(%{}, fn m, acc -> Map.merge(acc, m) end)

    uppercases =
      for i <- 65..90 do
        <<i::utf8>>
      end
      |> Enum.with_index()
      |> Enum.map(fn {l, i} -> %{l => i + 27} end)
      |> Enum.reduce(%{}, fn m, acc -> Map.merge(acc, m) end)

    letters = Map.merge(lowercases, uppercases)

    rucksacks_shared_item
    |> Enum.map(fn x -> Map.get(letters, x) end)
    |> Enum.sum()
  end
end
