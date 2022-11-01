defmodule Mix.Tasks.NewDay do
  use Mix.Task

  # (also just an exercise in creating a custom mixi task)
  @shortdoc "Creates a new template from boilerplate for AoC"
  def run([day | _tail]) do
    path = "lib/advent_of_code/#{day}.ex"

    templ = """
    # https://adventofcode.com/2022/day/CHANGEME

    defmodule AdventOfCode.#{String.capitalize(day)} do
      ####################################################################
      ## p1
      ####################################################################
      def first(input) do
      end

      ####################################################################
      ## p2
      ####################################################################
      def second(input) do
      end
    end
    """

    IO.puts(File.write(Path.relative(path), templ))
  end
end
