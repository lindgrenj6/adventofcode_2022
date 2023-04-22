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

  test "dec05" do
    aocautotest(
      AdventOfCode.raw_read_file("dec05.txt"),
      AdventOfCode.Dec05,
      ["BZLVHBWQF", "TDGJQTZSL"]
    )
  end

  test "dec06" do
    aocautotest(
      AdventOfCode.read_file("dec06.txt"),
      AdventOfCode.Dec06,
      [1238, 3037]
    )
  end

  test "dec07" do
    aocautotest(
      AdventOfCode.read_file("dec07.txt"),
      AdventOfCode.Dec07,
      [1_517_599, 2_481_982]
    )
  end

  test "dec08" do
    aocautotest(
      AdventOfCode.read_file("dec08.txt"),
      AdventOfCode.Dec08,
      [1736, 268_800]
    )
  end

  test "dec09" do
    aocautotest(
      AdventOfCode.read_file("dec09.txt"),
      # AdventOfCode.read_file("tinput.txt"),
      AdventOfCode.Dec09,
      [6486, 0]
      # [12, 0]
    )
  end

  test "dec10" do
    aocautotest(
      AdventOfCode.read_file("dec10.txt"),
      # AdventOfCode.read_file("tinput.txt"),
      AdventOfCode.Dec10,
      [14360, 0]
    )
  end

  test "dec11" do
    aocautotest(
      nil,
      AdventOfCode.Dec11,
      [88208, 21_115_867_968]
    )
  end

  test "dec13" do
    aocautotest(
      # AdventOfCode.raw_read_file("tinput.txt"),
      AdventOfCode.raw_read_file("dec13.txt"),
      AdventOfCode.Dec13,
      # [13, 0]
      [4643, 21614]
    )
  end

  test "dec20" do
    aocautotest(
      # AdventOfCode.read_file("tinput.txt"),
      AdventOfCode.read_file("dec20.txt"),
      AdventOfCode.Dec20,
      # [3, 1623178306]
      [3700, -2_385_260_520_667]
    )
  end

  @tag timeout: :infinity
  test "dec21" do
    aocautotest(
      AdventOfCode.read_file("tinput.txt"),
      # AdventOfCode.read_file("dec21.txt"),
      AdventOfCode.Dec21,
      [152, 0]
      # [309248622142100, 0]
    )
  end

  test "dec25" do
    aocautotest(
      AdventOfCode.read_file("tinput.txt"),
      # AdventOfCode.read_file("dec21.txt"),
      AdventOfCode.Dec25,
      [0, 0]
      # [309248622142100, 0]
    )
  end
end
