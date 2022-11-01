# https://adventofcode.com/2022/day/CHANGEME

defmodule AdventOfCode.TwentyTwentyOne.Dec05 do
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> parse()
    |> Enum.flat_map(&map_to_straight_line/1)
    |> Enum.frequencies()
    |> Enum.count(fn {_, count} -> count > 1 end)
  end

  @spec map_to_straight_line(%AdventOfCode.TwentyTwentyOne.Dec05{}) :: [[integer]]
  def map_to_straight_line(coord) when coord.startx == coord.endx do
    for y <- coord.starty..coord.endy, do: [coord.startx, y]
  end

  def map_to_straight_line(coord) when coord.starty == coord.endy do
    for x <- coord.startx..coord.endx, do: [x, coord.starty]
  end

  def map_to_straight_line(_), do: []

  ####################################################################
  ## p2
  ####################################################################

  defstruct ~w(startx starty endx endy)a

  @spec parse([String.t()]) :: [%AdventOfCode.TwentyTwentyOne.Dec05{}]
  def parse(input) do
    Enum.map(input, fn line ->
      [x, y] = String.split(line, " -> ")
      [startx, starty] = String.split(x, ",")
      [endx, endy] = String.split(y, ",")

      %AdventOfCode.TwentyTwentyOne.Dec05{
        startx: String.to_integer(startx),
        starty: String.to_integer(starty),
        endx: String.to_integer(endx),
        endy: String.to_integer(endy)
      }
    end)
  end

  def second(input) do
    input
    |> parse()
    |> Enum.flat_map(&map_to_line/1)
    |> Enum.frequencies()
    |> Enum.count(fn {_, count} -> count > 1 end)
  end

  @spec map_to_line(%AdventOfCode.TwentyTwentyOne.Dec05{}) :: [[integer]]
  def map_to_line(coord) when coord.startx == coord.endx, do: map_to_straight_line(coord)
  def map_to_line(coord) when coord.starty == coord.endy, do: map_to_straight_line(coord)

  '''
  Takes a coordinate and counts from bottom to top, be it in reverse or not.
  '''
  def map_to_line(coord) when coord.endy > coord.starty do
      coord.startx..coord.endx
      |> Enum.into([])
      |> points(coord.starty, 0)
  end

  def map_to_line(coord) when coord.endy < coord.starty do
      coord.endx..coord.startx
      |> Enum.into([])
      |> points(coord.endy, 0)
  end

  @spec points([[integer()]], integer(), integer()) :: [[integer()]]
  def points([], _, _), do: []

  def points([x | tail], b, n) do
    [[x, b+n] | points(tail, b, n + 1)]
  end
end
