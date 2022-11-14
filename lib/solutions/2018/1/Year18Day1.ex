defmodule Year18Day1 do
  def solve(input, :a) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
