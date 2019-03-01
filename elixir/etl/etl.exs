defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(%{"a" => ["ABILITY", "AARDVARK"], "b" => ["BALLAST", "BEAUTY"]})
  %{"ability" => "a", "aardvark" => "a", "ballast" => "b", "beauty" =>"b"}
  """
  @spec transform(map) :: map
  def transform(input) do
    input
    |> Map.keys()
    |> Enum.map(fn x -> {Map.get(input, x), x} end)
    |> Enum.flat_map(fn {x, y} -> Enum.map(x, fn z -> {z, y} end) end)
    |> Enum.map(fn {x, y} -> {String.downcase(x), y} end)
    |> Map.new()
  end
end
