# https://adventofcode.com/2022/day/CHANGEME

defmodule AdventOfCode.TwentyTwentyOne.Dec03 do
  ####################################################################
  ## p1
  ####################################################################
  @spec first([String.t()]) :: number
  def first(input) do
    input
    |> AdventOfCode.map_to_codepoints()
    |> Enum.map(&AdventOfCode.list_of_string_to_ints/1)
    |> AdventOfCode.transpose()
    |> Enum.map(&Enum.split_with(&1, fn x -> x == 0 end))
    |> Enum.map(fn {zeroes, ones} -> length(zeroes) > length(ones) end)
    |> run([], [])
  end

  defp run([], gamma, epsilon) do
    binary_to_int(gamma) * binary_to_int(epsilon)
  end

  defp run([true | tail], gamma, epsilon) do
    run(tail, [0 | gamma], [1 | epsilon])
  end

  defp run([false | tail], gamma, epsilon) do
    run(tail, [1 | gamma], [0 | epsilon])
  end

  defp binary_to_int(num) do
    num
    |> Enum.reverse()
    |> Enum.join()
    |> String.to_integer(2)
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    bits =
      input
      |> AdventOfCode.map_to_codepoints()
      |> Enum.map(&AdventOfCode.list_of_string_to_ints/1)

    o2_rating(bits, 0) * co2_rating(bits, 0)
  end

  def o2_rating([final], _), do: binary_to_int(Enum.reverse(final))

  def o2_rating(bits, position) do
    bit =
      case Enum.at(bit_counts(bits), position) do
        {_, true} -> 1
        {true, _} -> 1
        {false, _} -> 0
      end

    o2_rating(
      Enum.filter(bits, fn row -> Enum.at(row, position) == bit end),
      position + 1
    )
  end

  def co2_rating([final], _), do: binary_to_int(Enum.reverse(final))

  def co2_rating(bits, position) do
    bit =
      case Enum.at(bit_counts(bits), position) do
        {_, true} -> 0
        {true, _} -> 0
        {false, _} -> 1
      end

    co2_rating(
      Enum.filter(bits, fn row -> Enum.at(row, position) == bit end),
      position + 1
    )
  end

  def bit_counts(input) do
    input
    |> AdventOfCode.transpose()
    |> Enum.map(&Enum.split_with(&1, fn x -> x == 0 end))
    |> Enum.map(fn {zeroes, ones} ->
      {length(ones) > length(zeroes), length(ones) == length(zeroes)}
    end)
  end
end
