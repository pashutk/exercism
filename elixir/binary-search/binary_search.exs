defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """
  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key), do: do_search(numbers, key, 0, tuple_size(numbers) - 1)

  defp do_search({}, _key, _start_pos, _end_pos), do: :not_found

  defp do_search(_numbers, _key, start_pos, end_pos) when start_pos > end_pos do
    raise("Wrong search interval")
  end

  defp do_search(numbers, key, start_pos, end_pos) when end_pos - start_pos <= 1 do
    cond do
      elem(numbers, start_pos) == key -> {:ok, start_pos}
      elem(numbers, end_pos) == key -> {:ok, end_pos}
      true -> :not_found
    end
  end

  defp do_search(numbers, key, start_pos, end_pos) do
    mid = div(end_pos - start_pos, 2) + start_pos
    mid_elem = elem(numbers, mid)

    cond do
      mid_elem == key -> {:ok, mid}
      mid_elem > key -> do_search(numbers, key, start_pos, mid)
      mid_elem < key -> do_search(numbers, key, mid, end_pos)
    end
  end
end
