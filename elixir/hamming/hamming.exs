defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2), do: hamming_distance(strand1, strand2, {:ok, 0})
  defp hamming_distance('', '', acc), do: acc

  defp hamming_distance(strand1, strand2, _acc) when strand1 == [] or strand2 == [],
    do: {:error, "Lists must be the same length"}

  defp hamming_distance([nuc1 | strand1], [nuc2 | strand2], {status, acc}) do
    hamming_distance(
      strand1,
      strand2,
      {status,
       acc +
         case nuc1 == nuc2 do
           true -> 0
           false -> 1
         end}
    )
  end
end
