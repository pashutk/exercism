defmodule RNATranscription do
  @rna_map %{
    ?G => ?C,
    ?C => ?G,
    ?T => ?A,
    ?A => ?U,
  }

  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(list), do: Enum.map(list, &rna_mapper/1)

  defp rna_mapper(item), do: Map.get(@rna_map, item, item)
end
