defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(_s, slice_size) when slice_size <= 0, do: []
  def slices(s, slice_size) do
    cond do
      String.length(s) < slice_size -> []
      true -> [String.slice(s, 0, slice_size) | slices(String.slice(s, 1, String.length(s)), slice_size)]
    end
  end
end
