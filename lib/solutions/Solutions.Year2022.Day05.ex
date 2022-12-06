defmodule Solutions.Year2022.Day05 do
  @moduledoc """
  Solutions for Year 2022 and Day 5
  """

  # Test input
  # input = File.read!("./lib/inputs/2022_5_test.txt")

  defmacro __using__(_opts) do
    quote do
      def solve(input, 22_05_01) do
        %{cargo: cargo, moves: moves} = SupplyStacks.parse(input)
        cargo = SupplyStacks.move_boxes(moves, cargo, false)
        SupplyStacks.get_top_boxes(cargo)
      end

      def solve(input, 22_05_02) do
        %{cargo: cargo, moves: moves} = SupplyStacks.parse(input)
        cargo = SupplyStacks.move_boxes(moves, cargo, true)
        SupplyStacks.get_top_boxes(cargo)
      end
    end
  end
end

defmodule SupplyStacks do
  @moduledoc """
   Supply stack helpers
  """
  def parse(input) do
    [cargo, moves] = String.split(input, "\n\n")

    cargo =
      cargo
      |> String.split("\n")
      |> Enum.take_while(fn line ->
        String.contains?(line, "1") == false
      end)
      |> Enum.map(fn x ->
        x
        |> String.replace("    ", "[-]")
        |> String.replace("]", "")
        |> String.split("[", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.with_index()
        |> Enum.filter(fn {c, _i} -> c != "-" end)
      end)
      |> List.flatten()
      |> Enum.group_by(
        fn {_letter, index} -> index + 1 end,
        fn {letter, _index} -> letter end
      )

    moves =
      moves
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->
        [number_of_boxes_text, from_to_text] = String.split(row, " from ")

        count =
          String.split(number_of_boxes_text, " ", trim: true)
          |> Enum.at(-1)
          |> String.to_integer()

        [from, to] =
          String.split(from_to_text, " to ", trim: true)
          |> Enum.map(&String.to_integer/1)

        %{count: count, from: from, to: to, row: row}
      end)

    %{cargo: cargo, moves: moves}
  end

  def move_boxes(moves, cargo, keep_order) do
    if Enum.empty?(moves) do
      cargo
    else
      %{count: count, from: from, to: to} = hd(moves)
      from_box = Map.get(cargo, from)
      to_box = Map.get(cargo, to)
      to_be_moved = Enum.take(from_box, count)

      to_be_moved =
        if keep_order do
          to_be_moved
        else
          Enum.reverse(to_be_moved)
        end

      from_box = from_box -- to_be_moved
      to_box = to_be_moved ++ to_box

      new_cargo =
        Map.put(cargo, from, from_box)
        |> Map.put(to, to_box)

      move_boxes(tl(moves), new_cargo, keep_order)
    end
  end

  def get_top_boxes(cargo) do
    Map.to_list(cargo)
    |> Enum.map(fn {_, x} -> x end)
    |> Enum.map_join(fn x -> Enum.at(x, 0) end)
  end
end
