defmodule Year18Day01 do
  use ExUnit.Case
  doctest Aoc
  doctest Solutions.Year2018.Day02

  test "18_01_01" do
    assert 490 == Aoc.get(18_01_01).answer
  end

  test "18_01_02" do
    assert 70357 == Aoc.get(18_01_02).answer
  end

  test "18_02_01_test_data" do
    input = """
    abcdef
    bababc
    abbcde
    abcccd
    aabcdd
    abcdee
    ababab
    """

    sln = Solutions.Year2018.Day02.partOne(input)
    assert 12 = sln
  end
end
