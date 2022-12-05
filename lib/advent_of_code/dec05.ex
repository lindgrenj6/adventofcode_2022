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

    # store the stacks as a list of pids, each is an agent containing the state for that stack.
    stacks =
      for _ <- 1..length(List.first(raw)) do
        case Agent.start_link(fn -> Stack.new() end) do
          {:ok, pid} -> pid
          _ -> raise "failed to create agent"
        end
      end

    parse_stack(raw, stacks)
  end

  defp parse_stack([], stacks), do: stacks

  defp parse_stack([line | tail], stacks) do
    line
    |> with_index()
    |> each(fn
      # ignore the " " since we want a clean stack
      {" ", _} -> nil
      # otherwise, replace the current list with one appended.
      {item, idx} -> Agent.update(at(stacks, idx), fn stack -> Stack.push(stack, item) end)
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
    |> map(&Agent.get(&1, fn stack -> Stack.peek(stack) end))
    |> join()
  end

  def run({[{count, from, to} | tail], stacks}) do
    fromStack = at(stacks, from - 1)
    toStack = at(stacks, to - 1)

    for _ <- 1..count do
      item = Agent.get_and_update(fromStack, fn stack -> Stack.pop(stack) end)
      Agent.update(toStack, fn stack -> Stack.push(stack, item) end)
    end

    run({tail, stacks})
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
    |> map(&Agent.get(&1, fn stack -> Stack.peek(stack) end))
    |> join()
  end

  def runP2({[{count, from, to} | tail], stacks}) do
    fromStack = at(stacks, from - 1)
    toStack = at(stacks, to - 1)

    # much cleaner now that we can grab many at a time
    items = Agent.get_and_update(fromStack, fn stack -> Stack.pop_many(stack, count) end)
    Agent.update(toStack, fn stack -> Stack.push_many(stack, items) end)
    runP2({tail, stacks})
  end
end
