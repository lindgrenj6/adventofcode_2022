# https://adventofcode.com/2022/day/CHANGEME

defmodule AdventOfCode.Dec11 do
  ####################################################################
  ## p1
  ####################################################################
  def first(_input) do
    {out, 0} = System.cmd("go", ["run", "lib/advent_of_code/other/dec11.go"])
    out
    |> String.trim()
    |> String.to_integer()
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    0
  end
end
