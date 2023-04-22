# https://adventofcode.com/2022/day/9

defmodule AdventOfCode.Dec09 do
  alias AdventOfCode.Dec09
  alias AdventOfCode.Point

  import Enum

  defstruct head: %Point{}, tail: %Point{}

  @size 1000

  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    {:ok, grid} = Agent.start_link(fn -> %{} end)

    input
    |> parse()
    |> travel(%Dec09{}, grid)
    |> Agent.get(& &1)
    |> map_size()
  end

  def parse(input) do
    input
    |> map(&Regex.scan(~r/^(\w) (\d+)/, &1, capture: :all_but_first))
    |> List.flatten()
    |> chunk_every(2)
    |> map(fn [dir, amt] -> {dir, String.to_integer(amt)} end)
  end

  def travel([], _state, grid), do: grid

  def travel([{dir, amount} | tail], state, grid) do
    # do the actual travel
    {state, grid} = follow(dir, amount, state, grid)
    travel(tail, state, grid)
  end

  # reached the end
  def follow(_dir, 0, state, grid), do: {state, grid}

  def follow(dir, amt, state, grid) do
    moved = Point.move(state.head, dir)

    new = %Dec09{
      head: moved,
      tail:
        if Point.within(moved, state.tail, 2) do
          state.tail
        else
          state.head
        end
    }

    Agent.update(grid, fn grid -> Map.put(grid, new.tail, true) end)
    follow(dir, amt - 1, new, grid)
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    0
    # {:ok, grid} = Agent.start_link(fn -> %{} end)

    # input
    # |> parse()
    # |> fling(List.duplicate(%Point{}, 10), grid)
    # |> Agent.get(& &1)
    # |> map_size()
  end

  def fling([], _state, grid), do: grid

  def fling([{dir, amount} | tail], snake, grid) do
    # do the actual travel
    {snake, grid} = chain(dir, amount, snake, grid)
    fling(tail, snake, grid)
  end

  def chain(_dir, 0, snake, grid), do: {snake, grid}

  def chain(dir, amt, [head | snake], grid) do
    moved = Point.move(head, dir)
    snake = follow_head([moved | snake], head)

    Agent.update(grid, fn grid -> Map.put(grid, List.last(snake), true) end)
    chain(dir, amt - 1, snake, grid)
  end

  def follow_head(snake, _last) when length(snake) == 1, do: snake

  def follow_head([head | tail], last) do
    [next | rest] = tail

    if Point.within(head, next, 2) do
      # the rest of the snake won't move if it's within the limit
      [head | tail]
    else
      [head | follow_head([last | rest], next)]
    end
  end
end
