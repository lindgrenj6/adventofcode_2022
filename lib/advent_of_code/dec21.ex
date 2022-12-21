# https://adventofcode.com/2022/day/21

defmodule AdventOfCode.Dec21 do
  defstruct value: nil, left: nil, right: nil, op: nil
  alias AdventOfCode.Dec21
  import Enum

  def parse(item, monkeys) do
    if Regex.match?(~r/(\w+): (\d+)/, item) do
      [[_, name, value]] = Regex.scan(~r/(\w+): (\d+)/, item)
      Map.put(monkeys, String.to_atom(name), %Dec21{value: String.to_integer(value)})
    else
      [[_, name, left, op, right]] = Regex.scan(~r/(\w+): (\w+)\s(\+|\-|\*|\/)\s(\w+)/, item)

      Map.put(monkeys, String.to_atom(name), %Dec21{
        left: String.to_atom(left),
        right: String.to_atom(right),
        op: String.to_atom(op)
      })
    end
  end

  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> reduce(%{}, &parse/2)
    |> yell()
  end

  def yell(monkeys) do
    if monkeys[:root].value != nil do
      monkeys[:root].value
    else
      Map.keys(monkeys)
      |> reduce(monkeys, fn name, acc ->
        monkey = acc[name]
        Map.put(acc, name, yell(monkey, acc[monkey.left], acc[monkey.right]))
      end)
      |> yell()
    end
  end

  def yell(%Dec21{value: nil} = monkey, left, right) do
    if left.value != nil && right.value != nil do
      value =
        case monkey.op do
          :+ -> left.value + right.value
          :- -> left.value - right.value
          :* -> left.value * right.value
          :/ -> div(left.value, right.value)
        end

      %Dec21{value: value, op: monkey.op, left: monkey.left, right: monkey.right}
    else
      monkey
    end
  end

  # if the monkey already has a score
  def yell(%Dec21{value: x} = monkey, _left, _right) when is_integer(x), do: monkey

  ####################################################################
  ## p2
  ####################################################################
  def second(_input) do
    0
  end
end
