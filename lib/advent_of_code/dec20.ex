# https://adventofcode.com/2022/day/20

defmodule AdventOfCode.Dec20 do
  defstruct num: nil, visited: false
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
  def mix(list, count) when count >= length(list), do: list

  def mix(list, count) do
    {coord, idx} = find_first_unvisited(list)
    moved = List.delete_at(list, idx)
    pos = rem(idx + fix_position(coord.num), length(moved))
    moved = List.insert_at(moved, pos, %Dec20{num: coord.num, visited: true})

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
    0

    # was hoping it would be this simple - but apparently not. it's something to
    # do with "the order in which you mix doesn't change"

    # input
    # |> AdventOfCode.list_of_string_to_ints()
    # |> map(&parse(&1, 811589153))
    # |> mix(0)
    # |> map(&(%Dec20{num: &1.num}))
    # |> mix(0)
    # |> map(&(%Dec20{num: &1.num}))
    # |> mix(0)
    # |> map(&(%Dec20{num: &1.num}))
    # |> mix(0)
    # |> map(&(%Dec20{num: &1.num}))
    # |> mix(0)
    # |> map(&(%Dec20{num: &1.num}))
    # |> mix(0)
    # |> map(&(%Dec20{num: &1.num}))
    # |> mix(0)
    # |> map(&(%Dec20{num: &1.num}))
    # |> mix(0)
    # |> map(&(%Dec20{num: &1.num}))
    # |> mix(0)
    # |> map(&(%Dec20{num: &1.num}))
    # |> mix(0)
    # |> Stream.cycle()
    # |> find_grove_coordinates()
    # |> sum()
  end
end
