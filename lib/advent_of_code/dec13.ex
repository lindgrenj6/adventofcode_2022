# https://adventofcode.com/2022/day/13

defmodule AdventOfCode.Dec13 do
  import Enum

  ####################################################################
  ## p1
  ####################################################################
  def first(input) do
    input
    |> chunk_by(&(&1 == ""))
    |> reject(&(&1 == [""]))
    |> map(&map(&1, fn line -> Jason.decode!(line) end))
    |> with_index()
    |> filter(fn {[left, right], _idx} -> process_signal(left, right) end)
    |> map(fn {_, idx} -> idx + 1 end)
    |> sum()
  end

  def process_signal(left, right) do
    l = max([length(left), length(right)]) - 1

    map(0..l, fn i -> {left |> at(i), right |> at(i)} end)
    |> map(&in_order/1)
    |> reject(&(&1 == :eq))
    # added the default statement for part 2 which handles when there is an empty list.
    # this didn't occur in part 1
    |> List.first(true)
  end

  def in_order({a, a}), do: :eq
  def in_order({a, b}) when is_integer(a) and is_list(b), do: in_order({[a], b})
  def in_order({a, b}) when is_integer(b) and is_list(a), do: in_order({a, [b]})

  def in_order({[a | _left], [b | _right]}) when is_list(a) and is_integer(b), do: in_order({a, [b]})
  def in_order({[a | _left], [b | _right]}) when is_list(b) and is_integer(a), do: in_order({[a], b})
  def in_order({[a | left], [a | right]}) when is_integer(a), do: in_order({left, right})

  def in_order({[a | left], [b | right]}) when is_list(a) and is_list(b) do
    res = in_order({a, b})
    if res == :eq do
      in_order({left, right})
    else
      res
    end
  end

  def in_order({[a | _left], [b | _right]}), do: a < b

  def in_order({_, []}), do: false
  def in_order({_, nil}), do: false
  def in_order({[], _}), do: true
  def in_order({nil, _}), do: true

  ####################################################################
  ## p2
  ####################################################################
  def second(input) do
    input
    |> reject(&(&1 == ""))
    |> map(fn line -> Jason.decode!(line) end)
    |> Kernel.++([[[2]], [[6]]])
    |> sort(&process_signal/2)
    |> with_index(1)
    # really happy with this reduction. so fancy.
    |> reduce(1, fn
      {[[2]], idx}, acc -> acc * idx
      {[[6]], idx}, acc -> acc * idx
      _, acc -> acc
    end)
  end
end
