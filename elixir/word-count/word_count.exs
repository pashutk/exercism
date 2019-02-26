defmodule Words do
  @split_regex ~r/_+|[^\w\-]+/u

  @doc """
  Count the number of words in the sentence using @split_regex

  _ symbol considered as whitespace.
  - considered as non whitespace symbol.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    @split_regex
    |> Regex.split(sentence, trim: true)
    |> Enum.map(&String.downcase/1)
    |> Enum.reduce(%{}, &reduce_occurrences/2)
  end

  defp increment(number), do: number + 1

  defp reduce_occurrences(value, acc) do
    acc
    |> Map.update(value, 1, &increment/1)
  end
end
