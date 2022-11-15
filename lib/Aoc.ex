defmodule Aoc do
  @moduledoc """
  This is the main Advent Of Code module that wraps everything
  """
  import Helpers
  import Year18Day1

  def get(year_day_level) do
    [year, day, level] = parse(year_day_level)
    input = get_input(year, day)
    answer = solve(input, year_day_level)
    %{year: year, day: day, level: level, answer: answer}
  end

  def submit(%{year: year, day: day, level: level, answer: answer}) do
    post_answer(year, day, level, answer)
  end
end
