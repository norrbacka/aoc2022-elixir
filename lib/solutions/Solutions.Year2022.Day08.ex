defmodule Solutions.Year2022.Day08 do
  @moduledoc """
  Solutions for Year 2022 and Day 8
  """
  defmacro __using__(_opts) do
    quote do
      def solve(input, 22_08_01) do
        trees =
          String.split(input, "\n", trim: true)
          |> Enum.with_index()
          |> Enum.map(fn {row, y} ->
            columns =
              String.graphemes(row)
              |> Enum.with_index()
              |> Enum.map(fn {c, x} ->
                %{
                  x: x,
                  y: y,
                  h: String.to_integer(c)
                }
              end)
          end)

        top_edge = 0
        right_edge = length(Enum.at(trees, 0)) - 1
        bottom_edge = length(trees) - 1
        left_edge = 0

        flat_trees = List.flatten(trees)

        visible =
          flat_trees
          |> Enum.filter(fn %{h: h, x: x, y: y} ->
            is_edge(x, y, top_edge, bottom_edge, right_edge, left_edge) ||
              has_shorter_neighbour(flat_trees, x, y, h)
          end)
          |> Enum.count()
      end

      def is_edge(x, y, top_edge, bottom_edge, right_edge, left_edge) do
        Enum.member?([top_edge, bottom_edge], y) ||
          Enum.member?([left_edge, right_edge], x)
      end

      def has_shorter_neighbour(flat_trees, x, y, h) do
        lefts =
          Enum.filter(flat_trees, fn t -> t.x < x and t.y == y end)
          |> Enum.map(fn x -> x.h end)

        rights =
          Enum.filter(flat_trees, fn t -> t.x > x and t.y == y end)
          |> Enum.map(fn x -> x.h end)

        tops =
          Enum.filter(flat_trees, fn t -> t.x == x and t.y < y end)
          |> Enum.map(fn x -> x.h end)

        bottoms =
          Enum.filter(flat_trees, fn t -> t.x == x and t.y > y end)
          |> Enum.map(fn x -> x.h end)

        Enum.all?(lefts, fn x -> x < h end) ||
          Enum.all?(rights, fn x -> x < h end) ||
          Enum.all?(tops, fn x -> x < h end) ||
          Enum.all?(bottoms, fn x -> x < h end)
      end

      def solve(input, 22_08_02) do
        test = """
        30373
        25512
        65332
        33549
        35390
        """

        trees =
          String.split(input, "\n", trim: true)
          |> Enum.with_index()
          |> Enum.map(fn {row, y} ->
            columns =
              String.graphemes(row)
              |> Enum.with_index()
              |> Enum.map(fn {c, x} ->
                %{
                  x: x,
                  y: y,
                  h: String.to_integer(c)
                }
              end)
          end)

        top_edge = 0
        right_edge = length(Enum.at(trees, 0)) - 1
        bottom_edge = length(trees) - 1
        left_edge = 0

        flat_trees = List.flatten(trees)

        highest_score =
          flat_trees
          |> Enum.map(fn %{h: h, x: x, y: y} ->
            %{x: x, y: y, h: h, scenic_score: scenic_score(flat_trees, x, y, h)}
          end)
          |> Enum.sort_by(fn x -> x.scenic_score.score end, :desc)
          |> Enum.at(0)

        highest_score.scenic_score.score
      end

      def take_until(items, i, taken \\ []) do
        cond do
          Enum.empty?(items) ->
            taken

          Enum.at(items, 0) < i ->
            taken = taken ++ [Enum.at(items, 0)]
            take_until(Enum.drop(items, 1), i, taken)

          Enum.at(items, 0) >= i ->
            taken = taken ++ [Enum.at(items, 0)]
            taken

          true ->
            taken
        end
      end

      def scenic_score(flat_trees, x, y, h) do
        lefts =
          Enum.filter(flat_trees, fn t -> t.x < x and t.y == y end)
          |> Enum.map(fn x -> x.h end)
          |> Enum.reverse()
          |> take_until(h)

        rights =
          Enum.filter(flat_trees, fn t -> t.x > x and t.y == y end)
          |> Enum.map(fn x -> x.h end)
          |> take_until(h)

        tops =
          Enum.filter(flat_trees, fn t -> t.x == x and t.y < y end)
          |> Enum.map(fn x -> x.h end)
          |> Enum.reverse()
          |> take_until(h)

        bottoms =
          Enum.filter(flat_trees, fn t -> t.x == x and t.y > y end)
          |> Enum.map(fn x -> x.h end)
          |> take_until(h)

        score = Enum.count(tops) * Enum.count(rights) * Enum.count(bottoms) * Enum.count(lefts)

        %{
          tops: tops,
          rights: rights,
          bottoms: bottoms,
          lefts: lefts,
          score: score
        }
      end
    end
  end
end
