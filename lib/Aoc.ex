defmodule Aoc do
  @moduledoc """
  This is the main Advent Of Code module that wraps everything
  """
  import Helpers

  # 2018 Solutions
  use Solutions.Year2018.Day01
  use Solutions.Year2018.Day02
  use Solutions.Year2018.Day03
  use Solutions.Year2018.Day04

  # 2022 Solutions
  use Solutions.Year2022.Day01
  use Solutions.Year2022.Day02
  use Solutions.Year2022.Day03
  use Solutions.Year2022.Day04
  use Solutions.Year2022.Day05
  use Solutions.Year2022.Day06
  use Solutions.Year2022.Day07
  use Solutions.Year2022.Day08
  use Solutions.Year2022.Day09
  use Solutions.Year2022.Day10
  use Solutions.Year2022.Day11
  use Solutions.Year2022.Day12
  use Solutions.Year2022.Day13
  use Solutions.Year2022.Day14
  use Solutions.Year2022.Day15
  use Solutions.Year2022.Day16
  use Solutions.Year2022.Day17
  use Solutions.Year2022.Day18
  use Solutions.Year2022.Day19
  use Solutions.Year2022.Day20
  use Solutions.Year2022.Day21
  use Solutions.Year2022.Day22
  use Solutions.Year2022.Day23
  use Solutions.Year2022.Day24
  use Solutions.Year2022.Day25
  use Application

  def start(_type, _args) do
    # For debugging in VS Code, when launcher.json is used to call "mix run" with debugging enabled
    # Then uncomment the section below and call the function you would like to debug
    # get(18_01_01)
    {:ok, self()}
  end

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
