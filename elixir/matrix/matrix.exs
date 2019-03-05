defmodule Matrix do
  defstruct items: [], rows_count: 0, columns_count: 0

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input) do
    rows = String.split(input, "\n")
    columns = String.split(Enum.at(rows, 0, []))

    %Matrix{
      items: Enum.flat_map(rows, &parse_row/1),
      rows_count: length(rows),
      columns_count: length(columns)
    }
  end

  defp parse_row(string) do
    string
    |> String.split()
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(fn {value, _} -> value end)
  end

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(matrix) do
    matrix
    |> Matrix.rows()
    |> Enum.map_join("\n", &Enum.join(&1, " "))
  end

  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(matrix), do: Enum.chunk_every(matrix.items, matrix.columns_count)

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(matrix, index) do
    matrix
    |> Matrix.rows()
    |> Enum.at(index)
  end

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(%{columns_count: 0}), do: []

  def columns(matrix) do
    0..(matrix.columns_count - 1)
    |> Enum.map(fn column ->
      matrix.items
      |> Enum.drop(column)
      |> Enum.take_every(matrix.rows_count)
    end)
  end

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(matrix, index) do
    matrix
    |> Matrix.columns()
    |> Enum.at(index)
  end
end
