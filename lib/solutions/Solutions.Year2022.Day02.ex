defmodule Solutions.Year2022.Day02 do
  @moduledoc """
  Solutions for Year 2022 and Day 2
  """
  defmacro __using__(_opts) do
    quote do
      import Solutions.Year2022.Day02

      def solve(input, 22_02_01) do
        array = RockPaperScissor.to_array_of_abc_and_xyz(input)
        moves = RockPaperScissor.to_strategy(array)
        result = RockPaperScissor.get_my_total_score(moves)
        result
      end

      def solve(input, 22_02_02) do
        array = RockPaperScissor.to_array_of_abc_and_xyz(input)
        moves = RockPaperScissor.to_strategy_based_upon_opponent(array)
        result = RockPaperScissor.get_my_total_score(moves)
        result
      end
    end
  end
end

defmodule RockPaperScissor do
  @moduledoc """
  Logic strategies to beat the Elf at rock, paper and scissor
  """

  def to_array_of_abc_and_xyz(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, " ") end)
  end

  def to_strategy(array) do
    Enum.map(array, fn [p1, p2] ->
      [
        case p1 do
          "A" -> :rock
          "B" -> :paper
          "C" -> :scissor
        end,
        case p2 do
          "X" -> :rock
          "Y" -> :paper
          "Z" -> :scissor
        end
      ]
    end)
  end

  def to_strategy_based_upon_opponent(array) do
    Enum.map(array, fn [p1, p2] ->
      a =
        case p1 do
          "A" -> :rock
          "B" -> :paper
          "C" -> :scissor
        end

      b = RockPaperScissor.select_shape(a, p2)
      [a, b]
    end)
  end

  def get_score(:rock, :rock), do: [1 + 3, 1 + 3]
  def get_score(:rock, :paper), do: [1 + 0, 2 + 6]
  def get_score(:rock, :scissor), do: [1 + 6, 3 + 0]

  def get_score(:paper, :rock), do: [2 + 6, 1 + 0]
  def get_score(:paper, :paper), do: [2 + 3, 2 + 3]
  def get_score(:paper, :scissor), do: [3 + 0, 3 + 6]

  def get_score(:scissor, :rock), do: [3 + 0, 1 + 6]
  def get_score(:scissor, :paper), do: [3 + 6, 2 + 0]
  def get_score(:scissor, :scissor), do: [3 + 3, 3 + 3]

  def select_shape(:rock, "X"), do: :scissor
  def select_shape(:rock, "Y"), do: :rock
  def select_shape(:rock, "Z"), do: :paper

  def select_shape(:paper, "X"), do: :rock
  def select_shape(:paper, "Y"), do: :paper
  def select_shape(:paper, "Z"), do: :scissor

  def select_shape(:scissor, "X"), do: :paper
  def select_shape(:scissor, "Y"), do: :scissor
  def select_shape(:scissor, "Z"), do: :rock

  def sum_both_players_scores(results) do
    results
    |> Enum.reduce(
      [0, 0],
      fn [a, b], [x, y] ->
        [a + x, b + y]
      end
    )
  end

  def get_my_total_score(moves) do
    scores = Enum.map(moves, fn [x, y] -> get_score(x, y) end)
    total_scores = sum_both_players_scores(scores)
    my_score = Enum.at(total_scores, -1)
    my_score
  end
end
