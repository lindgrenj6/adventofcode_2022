# https://adventofcode.com/2022/day/10

defmodule AdventOfCode.Dec10 do
  import Enum

  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    {:ok, memory} = Agent.start_link(fn -> %{} end)

    input
    |> parse()
    # initializing the pc to 1 and x register to 1
    |> run(1, 1, memory)

    Agent.get(memory, &Map.get(&1, :runtime))
    |> with_index()
    |> reduce([], fn {mem, index}, acc ->
      # this is ugly, but not sure if i could do it another way.
      case index do
        19 ->
          acc ++ [20 * mem]

        59 ->
          acc ++ [60 * mem]

        99 ->
          acc ++ [100 * mem]

        139 ->
          acc ++ [140 * mem]

        179 ->
          acc ++ [180 * mem]

        219 ->
          acc ++ [220 * mem]

        _ ->
          acc
      end
    end)
    |> sum()
  end

  def parse(input) do
    input
    |> map(fn
      "noop" ->
        {:noop, nil}

      line ->
        [op, amt] = String.split(line)
        {String.to_atom(op), String.to_integer(amt)}
    end)
  end

  def run([], counter, x_reg, memory) do
    Agent.update(memory, fn m ->
      rt = Map.get(m, :runtime, [])
      Map.put(m, :runtime, rt ++ [x_reg])
    end)

    [x_reg + Agent.get(memory, fn m -> Map.get(m, counter, 0) end)]
  end

  def run([{:addx, arg} | tail], counter, x_reg, memory) do
    count = Agent.get(memory, fn m -> Map.get(m, counter + 1, 0) end)

    Agent.update(memory, fn m ->
      Map.put(m, counter + 1, count + arg)
    end)

    Agent.update(memory, fn m ->
      rt = Map.get(m, :runtime, [])
      Map.put(m, :runtime, rt ++ [x_reg])
    end)

    run([{:noop, nil} | tail], counter + 1, x_reg, memory)
  end

  def run([{:noop, _} | tail], counter, x_reg, memory) do
    Agent.update(memory, fn m ->
      rt = Map.get(m, :runtime, [])
      Map.put(m, :runtime, rt ++ [x_reg])
    end)

    new = x_reg + Agent.get(memory, fn m -> Map.get(m, counter, 0) end)
    [new | run(tail, counter + 1, new, memory)]
  end

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    0
  end

  def _second(input) do
    {:ok, memory} = Agent.start_link(fn -> %{} end)

    {:ok, grid} =
      Agent.start_link(fn ->
        map(1..6, fn _ ->
          {:ok, row} = Agent.start_link(fn -> List.duplicate("", 40) end)
          row
        end)
      end)

    input
    |> parse()
    # initializing the pc to 1 and x register to 1
    |> run(1, 1, memory)

    rt = Agent.get(memory, &Map.get(&1, :runtime))

    # moving sprite
    0..240
    |> chunk_every(3, 1, :discard)
    |> zip(rt)
    |> each(&write_grid(&1, grid))

    pp(grid)
  end

  def pp(grid) do
    Agent.get(grid, & &1)
    |> map(&Agent.get(&1, fn row -> row end))
    |> each(&IO.puts(&1))
  end

  def write_grid({[idx | rest], x_reg}, grid) do
    x = div(idx, 40)

    Agent.update(grid, fn g ->
      Agent.update(at(g, x), fn row ->
        IO.puts(rem(idx, 40))

        if x_reg in [idx | rest] do
          List.replace_at(row, rem(idx, 40), "#")
        else
          List.replace_at(row, rem(idx, 40), ".")
        end
      end)

      g
    end)
  end
end
