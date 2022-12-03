# https://adventofcode.com/2022/day/3

defmodule AdventOfCode.Dec03 do
  @enumthing String.codepoints("_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
  defp score(letter), do: Enum.find_index(@enumthing, fn x -> x == letter end)

  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(fn contents ->
      # split the contents into 2 equal lists
      Enum.chunk_every(contents, div(length(contents), 2))
    end)
    |> Enum.map(fn [left, right] ->
      # find the intersection
      Enum.find(left, &(&1 in right))
    end)
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    input
    |> Enum.map(&String.codepoints/1)
    |> Enum.chunk_every(3)
    |> Enum.map(fn [i, j, k] -> Enum.find(i, &(&1 in j && &1 in k)) end)
    |> Enum.map(&score/1)
    |> Enum.sum()
  end
end
