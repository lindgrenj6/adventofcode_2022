# https://adventofcode.com/2022/day/20

defmodule AdventOfCode.Dec20 do
  defstruct num: nil, visited: false, order: nil
  alias AdventOfCode.Dec20

  @spec parse(integer(), integer()) :: %AdventOfCode.Dec20{num: integer(), visited: false}
  def parse(num, key \\ 1), do: %Dec20{num: num * key}

  import Enum

  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> AdventOfCode.list_of_string_to_ints()
    |> map(&parse/1)
    |> mix(0)
    |> Stream.cycle()
    |> find_grove_coordinates()
    |> sum()
  end

  @spec find_grove_coordinates(any) :: [integer()]
  def find_grove_coordinates(list) do
    zero = find_index(list, &(&1.num == 0))
    # Stream.cycle() takes care of the looping for us.
    [at(list, zero + 1000).num, at(list, zero + 2000).num, at(list, zero + 3000).num]
  end

  # base case, we mixed the whole thing!
  @spec mix([integer()], integer()) :: [integer()]
  def mix(list, count) when count == length(list), do: list
  def mix(list, count) do
    {coord, idx} = find_first_unvisited(list)
    moved = List.delete_at(list, idx)
    pos = rem(idx + fix_position(coord.num), length(moved))
    moved = List.insert_at(moved, pos, %Dec20{num: coord.num, order: count, visited: true})

    mix(moved, count + 1)
  end

  def find_first_unvisited(list), do: find_first_unvisited(list, 0)
  def find_first_unvisited([head | _tail], idx) when not head.visited, do: {head, idx}
  def find_first_unvisited([_head | tail], idx), do: find_first_unvisited(tail, idx + 1)

  # weirdness with negative numbers. apparently it expects +1 position if its
  # moving from right to left
  def fix_position(num) when num < 0, do: num - 1
  def fix_position(num), do: num

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    initial =
      input
      |> AdventOfCode.list_of_string_to_ints()
      |> map(&parse(&1, 811_589_153))
      |> mix(0)

    reduce(2..10, initial, fn _, acc ->
      # dbg(map(acc, & &1.num))
      mix_in_order(acc, 0)
    end)
    |> Stream.cycle()
    |> find_grove_coordinates()
    |> sum()
  end

  def mix_in_order(list, count) when count == length(list), do: list
  def mix_in_order(list, count) do
    {coord, idx} = find_ordered(list, count, 0)
    moved = List.delete_at(list, idx)
    pos = rem(idx + fix_position(coord.num), length(moved))
    moved = List.insert_at(moved, pos, coord)

    mix_in_order(moved, count + 1)
  end

  def find_ordered([head | _tail], order, idx) when head.order == order, do: {head, idx}
  def find_ordered([_head | tail], order, idx), do: find_ordered(tail, order, idx + 1)
end
