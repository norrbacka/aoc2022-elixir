defmodule Solutions.Year2018.Day02 do
  @moduledoc """
  Solutions for Year 2018 and Day 2
  """
  defmacro __using__(_opts) do
    quote do
      import Solutions.Year2018.Day02

      def solve(input, 18_02_01) do
        partOne(input)
      end

      def solve(input, 18_02_02) do
        "not implemented"
      end
    end
  end

  def partOne(input) do
    counts =
      input
      |> String.split()
      |> Enum.map(&String.codepoints/1)
      |> Enum.map(fn letters ->
        unique_letters = Enum.uniq(letters)

        count =
          for unique_letter <- unique_letters do
            for letter <- letters do
              if unique_letter == letter do
                1
              else
                0
              end
            end
            |> Enum.sum()
          end
          |> Enum.filter(fn c -> c > 1 end)

        count
      end)

    twos =
      counts
      |> Enum.map(fn count ->
        if Enum.member?(count, 2) do
          1
        else
          0
        end
      end)
      |> Enum.sum()

    threes =
      counts
      |> Enum.map(fn count ->
        if Enum.member?(count, 3) do
          1
        else
          0
        end
      end)
      |> Enum.sum()

    twos * threes
  end
end
