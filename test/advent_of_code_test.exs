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

  # for copy/paste easiness
  #   test "2022decXX" do
  #     aocautotest(
  #       AdventOfCode.read_file("decXX.txt"),
  #       [
  #         {&AdventOfCode.DecXX.first/1, 1715},
  #         {&AdventOfCode.DecXX.second/1, 1739}
  #       ]
  #     )
  #   end

    test "2022dec01" do
      aocautotest(
        AdventOfCode.raw_read_file("dec01.txt"),
        [
          {&AdventOfCode.Dec01.first/1, 72718},
          {&AdventOfCode.Dec01.second/1, 213089}
        ]
      )
    end
end
