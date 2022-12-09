defmodule AdventOfCode.Point do
  alias AdventOfCode.Point

  defstruct x: 0, y: 0

  def up(%Point{x: x, y: y} = _pt, amt \\ 1), do: %Point{x: x, y: y + amt}
  def down(%Point{x: x, y: y} = _pt, amt \\ 1), do: %Point{x: x, y: y - amt}
  def left(%Point{x: x, y: y} = _pt, amt \\ 1), do: %Point{x: x - amt, y: y}
  def right(%Point{x: x, y: y} = _pt, amt \\ 1), do: %Point{x: x + amt, y: y}

  def move(pt, dir) do
    case dir do
      "U" -> Point.up(pt)
      "D" -> Point.down(pt)
      "L" -> Point.left(pt)
      "R" -> Point.right(pt)
    end
  end

  def within(right, left, amount) do
    abs(right.x - left.x) < amount && abs(right.y - left.y) < amount
  end
end
