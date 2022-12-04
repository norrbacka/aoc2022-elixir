defmodule Solutions.Year2022.Day04 do
  @moduledoc """
  Solutions for Year 2022 and Day 4
  """
  defmacro __using__(_opts) do
    quote do
      def solve(input, 22_04_01) do
        elf_pairs =
          input
          |> String.split("\n", trim: true)
          |> Enum.map(fn x ->
            [elf1, elf2] =
              String.split(x, ",")
              |> Enum.map(fn elf ->
                [s, e] = String.split(elf, "-") |> Enum.map(&String.to_integer/1)
                %{start: s, end: e}
              end)
          end)

        overlaps =
          elf_pairs
          |> Enum.filter(fn [elf1, elf2] ->
            (elf1.start >= elf2.start && elf1.end <= elf2.end) ||
              (elf2.start >= elf1.start && elf2.end <= elf1.end)
          end)

        Enum.count(overlaps)
      end

      def solve(input, 22_04_02) do
        elf_pairs =
          input
          |> String.split("\n", trim: true)
          |> Enum.map(fn x ->
            [elf1, elf2] =
              String.split(x, ",")
              |> Enum.map(fn elf ->
                [s, e] = String.split(elf, "-") |> Enum.map(&String.to_integer/1)
                MapSet.new(Enum.to_list(s..e))
              end)
          end)

        overlaps =
          elf_pairs
          |> Enum.filter(fn [elf1, elf2] ->
            length(MapSet.to_list(MapSet.intersection(elf1, elf2))) > 0
          end)

        Enum.count(overlaps)
      end
    end
  end
end
