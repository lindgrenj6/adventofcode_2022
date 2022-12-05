defmodule AdventOfCodeTest do
  use ExUnit.Case

  # I got sick of re-writing the same block over and over again.
  # why not let a macro write tests for me.
  defmacro aocautotest(input, m, [p1, p2]) do
    quote do
      assert unquote(m).first(unquote(input)) == unquote(p1)
      assert unquote(m).second(unquote(input)) == unquote(p2)
    end
  end

  test "dec01" do
    aocautotest(
      AdventOfCode.raw_read_file("dec01.txt"),
      AdventOfCode.Dec01,
      [72718, 213_089]
    )
  end

  test "dec02" do
    aocautotest(
      AdventOfCode.read_file("dec02.txt"),
      AdventOfCode.Dec02,
      [15337, 11696]
    )
  end

  test "dec03" do
    aocautotest(
      AdventOfCode.read_file("dec03.txt"),
      AdventOfCode.Dec03,
      [7785, 2633]
    )
  end

  test "dec04" do
    aocautotest(
      AdventOfCode.read_file("dec04.txt"),
      AdventOfCode.Dec04,
      [487, 849]
    )
  end
end
