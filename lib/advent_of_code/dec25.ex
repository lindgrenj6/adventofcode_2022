# https://adventofcode.com/2022/day/CHANGEME

defmodule AdventOfCode.Dec25 do
  import Enum

  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> map(&String.codepoints/1)
    |> map(&reverse/1)
    |> map(&parse/1)
  end

  def parse(line) do
    line
    |> with_index(1)
    |> map(fn {value, place} ->
      case value do
        "0" -> 0
        "1" -> 1
        "2" -> 2* place
        "-"-> -1*place
        "=" -> -2*place
      end
    end)
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
  end
end
