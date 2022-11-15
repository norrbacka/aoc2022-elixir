defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "18_01_01" do
    assert 490 == Aoc.get(18_01_01).answer
  end

  test "18_01_02" do
    assert 70357 == Aoc.get(18_01_02).answer
  end
end
