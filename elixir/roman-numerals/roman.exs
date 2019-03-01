defmodule Roman do
  @num_list [
    {"M", 1000},
    {"CM", 900},
    {"D", 500},
    {"CD", 400},
    {"C", 100},
    {"XC", 90},
    {"L", 50},
    {"XL", 40},
    {"X", 10},
    {"IX", 9},
    {"V", 5},
    {"IV", 4},
    {"I", 1},
  ]

  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(number), do: do_numerals(number, @num_list)

  defp do_numerals(number, list) when number == 0 or length(list) == 0, do: ""
  defp do_numerals(number, [h | t]) when number >= elem(h, 1), do: elem(h, 0) <> do_numerals(number - elem(h, 1), [h | t])
  defp do_numerals(number, [_h | t]), do: do_numerals(number, t)
end
