defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) when length(a) == length(b), do: equal?(a, b)
  def compare(a, b) when length(a) > length(b), do: superlist?(a, b)
  def compare(a, b) when length(a) < length(b), do: sublist?(a, b)
  def compare(_a, _b), do: :unequal

  defp equal?([], []), do: :equal
  defp equal?([h_a | t_a], [h_b | t_b]) when h_a === h_b, do: equal?(t_a, t_b)
  defp equal?([h_a | _], [h_b | _]) when h_a !== h_b, do: :unequal

  defp superlist?([], []), do: :unequal
  defp superlist?([], _b), do: :unequal
  defp superlist?(a, b) do
    case List.starts_with?(a, b) do
      true -> :superlist
      false -> superlist?(tl(a), b)
    end
  end

  defp sublist?(a, b) do
    case superlist?(b, a) do
      :superlist -> :sublist
      result -> result
    end
  end
end
