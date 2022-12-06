# https://adventofcode.com/2022/day/6

defmodule AdventOfCode.Dec06 do
  import Enum

  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    List.first(input)
    |> String.codepoints()
    |> with_index()
    |> chunk_every(4, 1)
    |> find(fn group ->
      # the letters are unique if the lenghts are the change after running uniq on them
      length(uniq_by(group, fn {letter, _} -> letter end)) == length(group)
    end)
    |> grab()
  end

  # do some pattern matching so i dont have to deref with Enum.at()
  # length defaults to 4, so i can specify it later for part 2
  defp grab([{_, idx} | _], length \\ 4), do: idx + length

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    List.first(input)
    |> String.codepoints()
    |> with_index()
    |> chunk_every(14, 1)
    |> find(fn group ->
      # the letters are unique if the lenghts are the change after running uniq on them
      length(uniq_by(group, fn {letter, _} -> letter end)) == length(group)
    end)
    |> grab(14)
  end
end
