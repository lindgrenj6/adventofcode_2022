# https://adventofcode.com/2022/day/5

defmodule AdventOfCode.Dec05 do
  import Enum
  alias AdventOfCode.Stack

  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> chunk_by(&(&1 == ""))
    |> reject(&(&1 == [""]))
    |> parse()
    |> run()
  end

  def parse([rules, instructions]) do
    # note the reversal of order, want the list of instructions first.
    {parse_instructions(instructions, []), parse_stack(rules)}
  end

  def parse_stack(lines) do
    raw =
      lines
      # ok, starting from the bottom.
      |> reverse()
      # ...ignoring the 1...n instructions line
      |> slice(1..-1)
      # wait, what?
      |> map(&String.codepoints/1)
      # can't you use regex for this? please no
      |> map(&chunk_every(&1, 4))
      # (eyes bleeding)
      |> map(&map(&1, fn thingy -> at(thingy, 1) end))

    stacks = List.duplicate(%Stack{}, length(List.first(raw)))
    parse_stack(raw, stacks)
  end

  defp parse_stack([], stacks), do: stacks

  defp parse_stack([line | tail], stacks) do
    stacks =
      line
      |> with_index()
      |> reduce(stacks, fn
        # ignore the " " since we want a clean stack
        {" ", _}, acc -> acc
        # otherwise, replace the current list with one appended. immutability makes this painful.
        {item, idx}, acc -> List.replace_at(acc, idx, Stack.push(at(acc, idx), item))
      end)

    parse_stack(tail, stacks)
  end

  def parse_instructions([], instructions), do: instructions

  def parse_instructions([line | tail], instructions) do
    parsed =
      Regex.scan(~r/(\d+)+/, line, capture: :all_but_first)
      |> List.flatten()
      |> map(&String.to_integer/1)
      |> List.to_tuple()

    parse_instructions(tail, instructions ++ [parsed])
  end

  # reached the end, peek all the tops
  def run({[], stacks}) do
    stacks
    |> map(&Stack.peek/1)
    |> join()
  end

  def run({[{count, from, to} | tail], stacks}) do
    fromStack = at(stacks, from - 1)
    toStack = at(stacks, to - 1)

    {fromStack, toStack} = move(count, fromStack, toStack)

    # gotta replace these due to immutability
    stacks = List.replace_at(stacks, from - 1, fromStack)
    stacks = List.replace_at(stacks, to - 1, toStack)

    run({tail, stacks})
  end

  # counting down to 0, moving from one stack to the other
  def move(0, from, to), do: {from, to}

  def move(n, from, to) do
    {head, from} = Stack.pop(from)
    move(n - 1, from, Stack.push(to, head))
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    input
    |> chunk_by(&(&1 == ""))
    |> reject(&(&1 == [""]))
    |> parse()
    |> runP2()
  end

  def runP2({[], stacks}) do
    stacks
    |> map(&Stack.peek/1)
    |> join()
  end

  def runP2({[{count, from, to} | tail], stacks}) do
    fromStack = at(stacks, from - 1)
    toStack = at(stacks, to - 1)

    # much cleaner now that we can grab many at a time
    {items, fromStack} = Stack.pop_many(fromStack, count)
    toStack = Stack.push_many(toStack, items)

    stacks = List.replace_at(stacks, from - 1, fromStack)
    stacks = List.replace_at(stacks, to - 1, toStack)

    runP2({tail, stacks})
  end
end
