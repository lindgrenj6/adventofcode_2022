defmodule AdventOfCode do
  def testfile(), do: read_file("tinput.txt")

  def read_file(file) do
    File.read!("./input/#{file}") |> String.split("\n") |> Enum.reject(&(&1 == ""))
  end

  # Need this function for fields that have records delimited by blank lines.
  @spec raw_read_file(any) :: [binary]
  def raw_read_file(file) do
    File.read!("./input/#{file}") |> String.split("\n")
  end

  @spec list_of_string_to_ints(any) :: [integer()]
  def list_of_string_to_ints(list) do
    Enum.map(list, &String.to_integer/1)
  end

  @spec map_to_codepoints(any) :: [String.t()]
  def map_to_codepoints(line), do: Enum.map(line, &String.codepoints/1)

  # Shamelessly stolen: https://stackoverflow.com/a/29674651
  def benchmark(function) do
    function
    |> :timer.tc()
    |> elem(0)
    |> Kernel./(1_000_000)
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&Task.await/1)
  end

  def safe_convert_to_int(i) do
    try do
      String.to_integer(i)
    rescue
      # was not int, traumatized.
      ArgumentError -> i
    end
  end

  # honestly a beautiful function. zip the rows together then catenate all of
  # them to conveniently transpose a matrix.
  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
