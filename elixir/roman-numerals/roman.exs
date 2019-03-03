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
    {"I", 1}
  ]

  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(number), do: do_numerals(number, @num_list)

  defp do_numerals(_number, []), do: ""

  defp do_numerals(number, [{numeral, value} | _t] = list) when number >= value do
    numeral <> do_numerals(number - value, list)
  end

  defp do_numerals(number, [_h | t]), do: do_numerals(number, t)
end
