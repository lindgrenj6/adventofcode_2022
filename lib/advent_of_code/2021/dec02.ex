# https://adventofcode.com/2022/day/2

defmodule AdventOfCode.TwentyTwentyOne.Dec02 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [dir, amount] -> {String.to_atom(dir), String.to_integer(amount)} end)
    |> dive(0, 0)
  end

  @spec dive([{:down, number} | {:forward, number} | {:up, number}], number, number) :: number
  def dive([], x, y), do: x * y
  def dive([{:forward, amt} | tail], x, y), do: dive(tail, x + amt, y)
  def dive([{:down, amt} | tail], x, y), do: dive(tail, x, y + amt)
  def dive([{:up, amt} | tail], x, y), do: dive(tail, x, y - amt)

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    input
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [dir, amount] -> {String.to_atom(dir), String.to_integer(amount)} end)
    |> aim(0, 0, 0)
  end

  @spec aim([{:down, number} | {:forward, number} | {:up, number}], any, number, number) :: number
  def aim([], _, x, y), do: x * y
  def aim([{:down, amt} | tail], aim, x, y), do: aim(tail, aim + amt, x, y)
  def aim([{:up, amt} | tail], aim, x, y), do: aim(tail, aim - amt, x, y)
  def aim([{:forward, amt} | tail], aim, x, y), do: aim(tail, aim, x + amt, y + aim * amt)
end
