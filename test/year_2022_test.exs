defmodule Year22Day01 do
  use ExUnit.Case
  doctest Aoc

  test "22_01_01" do
    assert 490 == Aoc.get(22_01_01).answer
  end

  test "22_01_02" do
    assert 70357 == Aoc.get(22_01_02).answer
  end
end
