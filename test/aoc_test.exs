defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "1801-a" do
    assert 490 == Aoc.get_answer_for_part_1(1, 2018)
  end
end
