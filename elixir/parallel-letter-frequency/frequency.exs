defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    Task.async_stream(texts, &do_frequency/1, max_concurrency: workers)
    |> Stream.map(fn {:ok, value} -> value end)
    |> Enum.reduce(%{}, &merge_reducer/2)
  end

  defp merge_reducer(item, acc), do: Map.merge(item, acc, &sum_merge/3)

  defp sum_merge(_k, v1, v2), do: v1 + v2

  defp do_frequency(text) do
    text
    |> String.splitter("", trim: :true)
    |> Enum.reduce(%{}, &freq_reducer/2)
  end

  defp freq_reducer(item, acc) do
    cond do
      Regex.match?(~r(\p{L}), item) -> Map.update(acc, String.downcase(item), 1, &(&1 + 1))
      true -> acc
    end
  end
end
