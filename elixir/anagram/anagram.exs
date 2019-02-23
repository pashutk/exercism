defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    base
    |> word_to_charmap()
    |> filter_anagrams(candidates, base)
  end

  defp word_to_charmap(word) do
    word
    |> String.downcase()
    |> String.to_charlist()
    |> Enum.reduce(%{}, &map_increment_value/2)
  end

  defp map_increment_value(val, map), do: Map.update(map, val, 1, &(&1 + 1))

  defp filter_anagrams(base_map, candidates, base), do: Enum.filter(candidates, anagram_filter(base_map, base))

  defp anagram_filter(base_map, base), do: fn candidate ->
    candidate
    |> String.downcase()
    |> String.to_charlist()
    |> Enum.reduce_while(base_map, &candidate_reducer/2)
    |> map_with_zero_size?()
    |> true_and_strings_not_equal?(candidate, base)
  end

  defp candidate_reducer(val, acc) do
    decremented_map_val = Map.get(acc, val, 0) - 1
    cond do
      decremented_map_val == 0 -> {:cont, Map.delete(acc, val)}
      decremented_map_val == -1 -> {:halt, nil}
      true -> {:cont, Map.update(acc, val, 1, &(&1 - 1))}
    end
  end

  defp map_with_zero_size?(nil), do: false
  defp map_with_zero_size?(result) when map_size(result) == 0, do: true
  defp map_with_zero_size?(_result), do: false

  defp true_and_strings_not_equal?(true, string_1, string_2), do: String.downcase(string_1) != String.downcase(string_2)
  defp true_and_strings_not_equal?(_, _, _), do: false
end
