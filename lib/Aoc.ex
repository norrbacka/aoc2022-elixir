defmodule Aoc do
  import Helpers

  defp solve(1, 2018, input, :a), do: Year18Day1.solve(input, :a)

  def get_answer_for_part_1(day, year \\ 2022) do
    input = get(day, year)
    solve(day, year, input, :a)
  end
end
