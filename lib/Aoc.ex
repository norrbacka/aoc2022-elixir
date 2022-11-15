defmodule Aoc do
  import Helpers

  defp solve(1, 2018, input, level), do: Year18Day1.solve(input, level)

  def get(day, level, year \\ 2022) do
    input = get_input(day, year)
    answer = solve(day, year, input, level)
    %{year: year, day: day, level: level, answer: answer}
  end

  def submit(%{year: year, day: day, level: level, answer: answer}) do
    post_answer(year, day, level, answer)
  end
end
