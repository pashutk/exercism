defmodule RNATranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna('G' ++ t), do: 'C' ++ to_rna(t)
  def to_rna('C' ++ t), do: 'G' ++ to_rna(t)
  def to_rna('T' ++ t), do: 'A' ++ to_rna(t)
  def to_rna('A' ++ t), do: 'U' ++ to_rna(t)
  def to_rna([h | t]), do: [h] ++ to_rna(t)
  def to_rna([]), do: []
end
