# https://adventofcode.com/2022/day/4

defmodule AdventOfCode.Dec04 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> Enum.map(&parse/1)
    |> Enum.filter(fn {first, second} ->
      Enum.all?(first, &(&1 in second)) || Enum.all?(second, &(&1 in first))
    end)
    |> Enum.count()
  end

  def parse(line) do
    [_, sx, sy, ex, ey] = Regex.run(~r/(\d+)-(\d+),(\d+)-(\d+)/, line)
    {String.to_integer(sx)..String.to_integer(sy), String.to_integer(ex)..String.to_integer(ey)}
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    input
    |> Enum.map(&parse/1)
    |> Enum.filter(fn {first, second} ->
      # literally just changed all -> any for part 2 :|
      # second check is not needed due to short circuit
      Enum.any?(first, &(&1 in second)) #|| Enum.all?(second, &(&1 in first))
    end)
    |> Enum.count()
  end
end
