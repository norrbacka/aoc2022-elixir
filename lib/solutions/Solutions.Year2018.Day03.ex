defmodule Solutions.Year2018.Day03 do
  @moduledoc """
  Solutions for Year 2018 and Day 3
  """
  defmacro __using__(_opts) do
    quote do
      def solve(input, 18_03_01) do
        NoMatterHowYouSliceIt.partOne(input)
      end

      def solve(input, 18_03_02) do
        NoMatterHowYouSliceIt.partTwo(input)
      end
    end
  end
end

defmodule NoMatterHowYouSliceIt do
  def partOne(input) do
    maps =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn row ->
        parsed = parse_instruction(String.trim(row))
        %{id: parsed.id, map: mapify(parsed)}
      end)

    freq =
      maps
      |> Enum.flat_map(fn m -> m.map end)
      |> Enum.frequencies()

    :maps.filter(fn _, value -> value > 1 end, freq)
    |> Enum.count()
  end

  def parse_instruction(text) do
    [id, _, pos, size] = text |> String.split()

    [pos_x, pos_y] = String.split(pos, ",")

    [pos_y, _] = String.split(pos_y, ":")

    [width, height] =
      size
      |> String.split("x")

    %{
      :id => id,
      :pos_x => pos_x |> String.to_integer(),
      :pos_y => pos_y |> String.to_integer(),
      :width => width |> String.to_integer(),
      :height => height |> String.to_integer()
    }
  end

  def mapify(%{id: id, pos_x: pos_x, pos_y: pos_y, width: width, height: height}) do
    map =
      for y <- Enum.to_list(pos_y..(pos_y + height)),
          x <- Enum.to_list(pos_x..(pos_x + width)) do
        if x >= pos_x && x <= pos_x + (width - 1) && y >= pos_y && y <= pos_y + (height - 1) do
          %{x: x, y: y}
        else
          nil
        end
      end
      |> Enum.filter(fn x -> x != nil end)

    map
  end

  def partTwo(input) do
    maps =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn row ->
        parsed = parse_instruction(String.trim(row))
        %{id: parsed.id, map: MapSet.new(mapify(parsed))}
      end)

    without_intersection =
      Stream.filter(maps, fn map ->
        Enum.any?(maps, fn compare ->
          map != compare and
            MapSet.intersection(compare.map, map.map)
            |> MapSet.to_list()
            |> length > 0
        end) == false
      end)
      |> Enum.at(0)

    without_intersection.id
  end
end
