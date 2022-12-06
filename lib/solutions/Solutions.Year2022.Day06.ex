defmodule Solutions.Year2022.Day06 do
  @moduledoc """
  Solutions for Year 2022 and Day 6
  """
  defmacro __using__(_opts) do
    quote do
      def solve(input, 22_06_01) do
        input = String.graphemes(input)
        TuningTrouble.solve(input, 4)
      end

      def solve(input, 22_06_02) do
        input = String.graphemes(input)
        TuningTrouble.solve(input, 14)
      end
    end
  end
end

defmodule TuningTrouble do
  @moduledoc """
  Tuning trouble, bad impl
  """
  def solve(input, count \\ 4) do
    stream = Stream.cycle(input)
    solve(stream, count, [], 0)
  end

  def solve(stream, count, bag, index) do
    item = Enum.to_list(Stream.take(stream, 1))
    new_bag = item ++ bag
    last_count =
      if length(new_bag) <= 1 do
        new_bag
      else
        Enum.take(new_bag, count)
      end
    if length(Enum.uniq(last_count)) == count do
      index + 1
    else
      solve(Stream.drop(stream, 1), count, last_count, index + 1)
    end
  end

  def tests do
    IO.inspect(example_1: solve(String.graphemes("mjqjpqmgbljsphdztnvjfqwrcgsmlb")))
    IO.inspect(example_2: solve(String.graphemes("bvwbjplbgvbhsrlpgdmjqwftvncz")))
    IO.inspect(example_3: solve(String.graphemes("nppdvjthqldpwncqszvftbrmjlhg")))
    IO.inspect(example_4: solve(String.graphemes("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")))
    IO.inspect(example_5: solve(String.graphemes("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")))
  end

  def tests_2 do
    IO.inspect(example_1: solve(String.graphemes("mjqjpqmgbljsphdztnvjfqwrcgsmlb"), 14))
    IO.inspect(example_2: solve(String.graphemes("bvwbjplbgvbhsrlpgdmjqwftvncz"), 14))
    IO.inspect(example_3: solve(String.graphemes("nppdvjthqldpwncqszvftbrmjlhg"), 14))
    IO.inspect(example_4: solve(String.graphemes("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"), 14))
    IO.inspect(example_5: solve(String.graphemes("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"), 14))
  end
end
