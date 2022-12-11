# https://adventofcode.com/2022/day/CHANGEME

defmodule AdventOfCode.Dec11 do
  ####################################################################
  ## p1
  ####################################################################
  def first(_input) do
    {out, 0} = System.cmd("go", ["run", "lib/advent_of_code/other/dec11p1.go"])
    out
    |> String.to_integer()
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(_input) do
    {out, 0} = System.cmd("go", ["run", "lib/advent_of_code/other/dec11p2.go"])
    out
    |> String.to_integer()
  end
end
