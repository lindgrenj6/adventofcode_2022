# https://adventofcode.com/2022/day/8

defmodule AdventOfCode.Dec08 do
  import Enum

  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> map(&String.codepoints/1)
    |> map(&AdventOfCode.list_of_string_to_ints/1)
    |> find_visible()
    |> reduce(0, fn row, acc -> acc + count(row, &(&1 == true)) end)
  end

  def find_visible(grid) do
    transposed = AdventOfCode.transpose(grid)

    map(0..(length(grid) - 1), fn x ->
      map(0..(length(grid) - 1), fn y ->
        check_point({grid, transposed}, x, y)
      end)
    end)
  end

  # edges are always visible
  def check_point(_grids, 0, _y), do: true
  def check_point(_grids, _x, 0), do: true
  def check_point({grid, _transposed}, _x, y) when y == length(grid) - 1, do: true
  def check_point({grid, _transposed}, x, _y) when x == length(grid) - 1, do: true

  def check_point({grid, transposed}, x, y) do
    height = grid |> at(x) |> at(y)

    # basically going through the lists of ints for up/down left/right of the
    # point and seeing if _any_ of them peek through
    get_surrounding_trees({grid, transposed}, x, y)
    |> any?(fn surrounding ->
      any?(surrounding, fn side ->
        all?(side, &(&1 < height))
      end)
    end)
  end

  def get_surrounding_trees({grid, transposed}, x, y) do
    [rowl, rowr] = grid |> at(x) |> List.delete_at(y) |> split(y) |> Tuple.to_list()
    [coll, colr] = transposed |> at(y) |> List.delete_at(x) |> split(x) |> Tuple.to_list()

    # adding the reverse part for part 2, does not effect part 1 output
    [[reverse(rowl), rowr], [reverse(coll), colr]]
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    input
    |> map(&String.codepoints/1)
    |> map(&AdventOfCode.list_of_string_to_ints/1)
    |> find_view_score()
    |> List.flatten()
    |> max()
  end

  def find_view_score(grid) do
    transposed = AdventOfCode.transpose(grid)

    map(0..(length(grid) - 1), fn x ->
      map(0..(length(grid) - 1), fn y ->
        scenic_score({grid, transposed}, x, y)
      end)
    end)
  end

  # this is wrong technically, but theres no way any of these will be > an inner tree
  def scenic_score(_grids, 0, _y), do: 0
  def scenic_score(_grids, _x, 0), do: 0
  def scenic_score({grid, _transposed}, _x, y) when y == length(grid) - 1, do: 0
  def scenic_score({grid, _transposed}, x, _y) when x == length(grid) - 1, do: 0

  def scenic_score({grid, transposed}, x, y) do
    height = grid |> at(x) |> at(y)

    get_surrounding_trees({grid, transposed}, x, y)
    |> map(fn [left, right] -> [lookout(left, height, 0), lookout(right, height, 0)] end)
    |> List.flatten()
    |> Enum.reduce(fn score, acc -> score * acc end)
  end

  # stop once we hit one that meets or exceeds our treee height
  def lookout([], _, count), do: count
  def lookout([tree | _view], height, count) when tree >= height, do: count + 1

  def lookout([_ | view], height, count) do
    lookout(view, height, count + 1)
  end
end
