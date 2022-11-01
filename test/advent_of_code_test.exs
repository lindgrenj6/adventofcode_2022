defmodule AdventOfCodeTest do
  use ExUnit.Case

  # I got sick of re-writing the same block over and over again.
  # why not let a macro write tests for me.
  defmacro aocautotest(input, tests) do
    quote do
      Enum.each(unquote(tests), fn {f, a} ->
        assert f.(unquote(input)) == a
      end)
    end
  end

  test "2021dec01" do
    aocautotest(
      AdventOfCode.read_file("2021dec01.txt"),
      [
        {&AdventOfCode.TwentyTwentyOne.Dec01.first/1, 1715},
        {&AdventOfCode.TwentyTwentyOne.Dec01.second/1, 1739}
      ]
    )
  end

  test "2021dec02" do
    aocautotest(
      AdventOfCode.read_file("2021dec02.txt"),
      [
        {&AdventOfCode.TwentyTwentyOne.Dec02.first/1, 1_855_814},
        {&AdventOfCode.TwentyTwentyOne.Dec02.second/1, 1_845_455_714}
      ]
    )
  end

  test "2021dec03" do
    aocautotest(
      AdventOfCode.read_file("2021dec03.txt"),
      [
        {&AdventOfCode.TwentyTwentyOne.Dec03.first/1, 3_813_416},
        {&AdventOfCode.TwentyTwentyOne.Dec03.second/1, 2_990_784}
      ]
    )
  end

  test "2021dec05" do
    aocautotest(
      AdventOfCode.read_file("2021dec05.txt"),
      [
        {&AdventOfCode.TwentyTwentyOne.Dec05.first/1, 4873},
        {&AdventOfCode.TwentyTwentyOne.Dec05.second/1, 19472}
      ]
    )
  end
end
