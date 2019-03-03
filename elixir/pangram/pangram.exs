defmodule Pangram do
  @doc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox jumps over the lazy dog")
      true

  """

  @spec pangram?(String.t()) :: boolean
  def pangram?(sentence) do
    sentence
    |> String.split("")
    |> Enum.map(&String.downcase/1)
    |> Enum.reduce_while(get_alphabet_map(), &reducer/2)
    |> process_result()
  end

  defp get_alphabet_map() do
    ?a..?z
    |> Enum.map(&(List.to_string([&1])))
    |> Map.new(&({&1, 1}))
  end

  defp reducer(_val, acc) when acc == %{}, do: {:halt, true}
  defp reducer(val, acc), do: {:cont, Map.delete(acc, val)}

  defp process_result(true), do: true
  defp process_result(_result), do: false
end
