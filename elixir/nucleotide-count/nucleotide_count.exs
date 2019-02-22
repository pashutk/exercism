defmodule NucleotideCount do
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count([char], char) :: non_neg_integer
  def count(strand, nucleotide, sum \\ 0)
  def count('', _nucleotide, sum), do: sum
  def count([h | t], nucleotide, sum), do: count(t, nucleotide, sum + case h do
    ^nucleotide -> 1
    _ -> 0
  end)

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram([char]) :: map
  def histogram(strand) do
    Enum.reduce(
      strand,
      nucleotides_list_to_map(@nucleotides),
      fn cur, acc -> Map.update(acc, cur, 0, &(&1 + 1))end)
  end

  def nucleotides_list_to_map(list), do: Map.new(list, fn item -> {item, 0} end)

  def histogram1(strand), do: Map.new(@nucleotides, &({&1, count(strand, &1)}))
end
