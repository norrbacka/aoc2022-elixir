defmodule Solutions.Year2022.Day07 do
  @moduledoc """
  Solutions for Year 2022 and Day 7
  """
  defmacro __using__(_opts) do
    quote do
      def solve(input, 22_07_01) do
        test = """
        $ cd /
        $ ls
        dir a
        14848514 b.txt
        8504156 c.dat
        dir d
        $ cd a
        $ ls
        dir e
        29116 f
        2557 g
        62596 h.lst
        $ cd e
        $ ls
        584 i
        $ cd ..
        $ cd ..
        $ cd d
        $ ls
        4060174 j
        8033020 d.log
        5626152 d.ext
        7214296 k
        $ cd ..
        $ cd /
        $ ls
        dir a
        14848514 b.txt
        8504156 c.dat
        dir d
        $ cd a
        $ ls
        dir e
        29116 f
        2557 g
        62596 h.lst
        $ cd e
        $ ls
        584 i
        $ cd ..
        $ cd ..
        $ cd d
        $ ls
        4060174 j
        8033020 d.log
        5626152 d.ext
        7214296 k
        """

        parsed =
          input
          |> String.split("\n", trim: true)
          |> NoSpaceLeftOnDevice.traverse()
          |> Enum.uniq()

        dirs =
          parsed
          |> Enum.flat_map(fn x -> x.dirs end)
          |> Enum.uniq()

        sums =
          for dir <- dirs do
            sum =
              parsed
              |> Enum.filter(fn x -> Enum.any?(x.dirs, fn d -> d == dir end) end)
              |> Enum.map(fn x -> Map.get(x, :size, 0) end)
              |> Enum.sum()
          end
          |> Enum.filter(fn x -> x <= 100_000 end)
          |> Enum.sum()
      end

      def solve(_input, 22_07_02) do
        IO.puts("Not yet implemented")
      end
    end
  end
end

defmodule NoSpaceLeftOnDevice do
  def parse(dir, <<"$ cd ", new_dir::binary>>) do
    %{type: :cd, dir: dir, open: new_dir}
  end

  def parse(dir, <<"$ ls">>) do
    %{type: :ls, dir: dir}
  end

  def parse(dir, <<"dir ", opened_dir::binary>>) do
    %{type: :dir, dir: dir, opened: opened_dir}
  end

  def parse(dir, line) do
    [size, name] = String.split(line, " ")

    %{
      type: :size,
      dir: dir,
      size: String.to_integer(size),
      name: name
    }
  end

  def traverse([], _dir, disk) do
    disk
    |> Enum.map(fn x ->
      dirs =
        String.split(x.dir, "/")
        |> Enum.filter(fn x -> x != "" end)

      Map.merge(x, %{dirs: dirs})
    end)
  end

  def traverse(rows, dir \\ "", disk \\ []) do
    row = Enum.at(rows, 0)
    parsed = parse(dir, row)

    case parsed.type do
      :cd when parsed.open == ".." ->
        split = Enum.reverse(String.split(dir, "/"))
        new_dir = Enum.reverse(tl(split)) |> Enum.join("/")
        traverse(Enum.drop(rows, 1), new_dir, disk ++ [parsed])

      :cd when parsed.open != ".." ->
        new_dir =
          if String.at(dir, -1) == "/" do
            "#{dir}#{parsed.open}"
          else
            "#{dir}/#{parsed.open}"
          end

        traverse(Enum.drop(rows, 1), new_dir, disk ++ [parsed])

      _ ->
        traverse(Enum.drop(rows, 1), dir, disk ++ [parsed])
    end
  end
end
