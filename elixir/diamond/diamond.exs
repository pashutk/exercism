defmodule Diamond do
  @divider ?\s
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(charcode) when charcode in ?A..?Z do
    ?A..charcode
    |> Enum.to_list()
    |> Enum.with_index()
    |> Enum.map(&build_line(&1, charcode - ?A))
    |> mirror()
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end
  def build_shape(_), do: raise "Invalid input"

  defp mirror([]), do: []
  defp mirror(list), do: Enum.concat(list, Enum.reverse(list) |> tl())

  defp build_line({value, index}, width) do
    build_char_seq(value, index, width)
    |> mirror()
    |> String.Chars.to_string()
  end

  defp build_char_seq(value, 0, 0), do: [value]
  defp build_char_seq(_value, _index, 0), do: [@divider]

  defp build_char_seq(value, index, width) when width == index,
    do: [value | build_char_seq(value, index, width - 1)]

  defp build_char_seq(value, index, width), do: [@divider | build_char_seq(value, index, width - 1)]
end
