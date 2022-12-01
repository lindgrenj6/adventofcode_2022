# https://adventofcode.com/2022/day1

defmodule AdventOfCode.Dec01 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> parse()
    |> Enum.max()
  end

  # pulled out into separate func for part 2
  defp parse(input) do
    Enum.chunk_by(input, &(&1 == ""))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.map(&AdventOfCode.list_of_string_to_ints/1)
    |> Enum.map(&Enum.sum/1)
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    input
    |> parse()
    |> Enum.sort()
    |> Enum.slice(-3..-1)
    |> Enum.sum()
  end
end
