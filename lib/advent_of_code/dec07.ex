# https://adventofcode.com/2022/day/CHANGEME

defmodule AdventOfCode.Dec07 do
  alias AdventOfCode.TreeNode
  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    fs = TreeNode.new(%TreeNode{name: "/"})
    :ok = parse(input, fs)

    fs
    |> find_directories_under_size([], 100_000)
    |> Enum.map(&TreeNode.value/1)
    |> Enum.sum()
  end

  def parse([], _), do: :ok

  def parse([cmd | tail], cwd) do
    cond do
      cmd == "$ cd .." ->
        parse(tail, TreeNode.parent(cwd))

      String.starts_with?(cmd, "$ cd") ->
        [[_, change]] = Regex.scan(~r/\$ cd (\w+|\.{2}|\/)/, cmd)
        parse(tail, TreeNode.add_child(cwd, change, 0))

      # skip ls, since we have our cwd already
      cmd == "$ ls" ->
        parse(tail, cwd)

      # ignore any directories, they'll be created when we cd into them
      String.starts_with?(cmd, "dir") ->
        parse(tail, cwd)

      Regex.match?(~r/^(\d+).*$/, cmd) ->
        [[_, bytes]] = Regex.scan(~r/^(\d+).*$/, cmd)
        TreeNode.update(cwd, String.to_integer(bytes))
        parse(tail, cwd)
    end
  end

  def find_directories_under_size(node, directories, size) do
    found =
      TreeNode.children(node)
      |> Enum.reduce(directories, fn {_k, pid}, acc ->
        find_directories_under_size(pid, acc, size)
      end)

    if TreeNode.value(node) < size do
      [node | found]
    else
      found
    end
  end

  ####################################################################
  ## p2
  ####################################################################
  @max_size 70_000_000
  @wanted_size 30_000_000
  def second(input) do
    fs = TreeNode.new(%TreeNode{name: "/"})
    :ok = parse(input, fs)

    [total | rest] =
      fs
      |> find_directories_under_size([], @max_size)
      |> Enum.map(&TreeNode.value/1)

    unused = @max_size - total
    needed = @wanted_size - unused

    rest
    |> Enum.filter(&(&1 > needed))
    |> Enum.sort()
    |> List.first()
  end
end
