# https://adventofcode.com/2022/day/2

defmodule AdventOfCode.Dec02 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> Enum.map(&String.split/1)
    |> Enum.map(&map/1)
    |> play(0)
  end

  # map the lines to tuples of atoms
  def map([opponent, encrypted]) do
    {
      # change to an atom for easier pattern matching
      String.to_atom(opponent),
      # ...decrypt the opponent to make this cleaner
      case encrypted do
        "X" -> :A
        "Y" -> :B
        "Z" -> :C
      end
    }
  end

  # we played through the entire game!
  def play([], score), do: score

  # handle the tie first
  def play([{:A, :A} | tail], score), do: play(tail, score + 3 + 1)
  def play([{:B, :B} | tail], score), do: play(tail, score + 3 + 2)
  def play([{:C, :C} | tail], score), do: play(tail, score + 3 + 3)

  # then the wins
  def play([{:C, :A} | tail], score), do: play(tail, score + 6 + 1)
  def play([{:A, :B} | tail], score), do: play(tail, score + 6 + 2)
  def play([{:B, :C} | tail], score), do: play(tail, score + 6 + 3)

  # otherwise its a loss
  def play([{_, :A} | tail], score), do: play(tail, score + 1)
  def play([{_, :B} | tail], score), do: play(tail, score + 2)
  def play([{_, :C} | tail], score), do: play(tail, score + 3)

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    input
    |> Enum.map(&String.split/1)
    |> Enum.map(&to_tuple_of_atoms/1)
    |> playWithMap(0)
  end

  def playWithMap([], score), do: score

  # PLAY THE GAME
  def playWithMap([{val, :X} | tail], score), do: playWithMap(tail, score + lose_score(val))
  def playWithMap([{val, :Y} | tail], score), do: playWithMap(tail, score + 3 + tie_score(val))
  def playWithMap([{val, :Z} | tail], score), do: playWithMap(tail, score + 6 + win_score(val))

  # pattern match all the stuff. i could probably use a hash easier but lazy
  defp win_score(:A), do: 2
  defp win_score(:B), do: 3
  defp win_score(:C), do: 1

  defp tie_score(:A), do: 1
  defp tie_score(:B), do: 2
  defp tie_score(:C), do: 3

  defp lose_score(:A), do: 3
  defp lose_score(:B), do: 1
  defp lose_score(:C), do: 2

  # translate ["A", "b"] -> {:A, :B}
  defp to_tuple_of_atoms(stuff) do
    stuff
    |> Enum.map(&String.to_atom/1)
    |> List.to_tuple()
  end
end
