# https://adventofcode.com/2022/day/CHANGEME

defmodule AdventOfCode.TwentyTwentyOne.Dec01 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> AdventOfCode.list_of_string_to_ints()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> b > a end)
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    input
    |> AdventOfCode.list_of_string_to_ints()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum(&1))
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> b > a end)
  end
end
