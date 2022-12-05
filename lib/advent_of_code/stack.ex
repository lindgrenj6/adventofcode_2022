defmodule AdventOfCode.Stack do
  defstruct data: []

  def new(), do: %__MODULE__{}
  def new(data) when is_list(data), do: %__MODULE__{data: data}
  def new(_), do: raise("improper stack input - need a list")

  def push(%__MODULE__{data: elements}, item) do
    %__MODULE__{data: elements ++ [item]}
  end

  def push_many(%__MODULE__{data: elements}, items) do
    %__MODULE__{data: elements ++ items}
  end

  def pop(%__MODULE__{data: elements}) when length(elements) == 0, do: nil
  def pop(%__MODULE__{data: elements}) do
    tail = Enum.at(elements, length(elements)-1)
    rest = List.delete_at(elements, length(elements)-1)
    {tail, %__MODULE__{data: rest}}
  end

  def pop_many(%__MODULE__{data: elements}, count) do
    tail = Enum.slice(elements, count*-1..-1)
    rest = Enum.slice(elements, 0..count*-1-1)

    {tail, %__MODULE__{data: rest}}
  end

  def peek(%__MODULE__{data: elements}) when length(elements) == 0, do: nil
  def peek(%__MODULE__{data: elements}) do
    Enum.at(elements, length(elements)-1)
  end
end
