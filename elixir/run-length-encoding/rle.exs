defmodule RunLengthEncoder do
  defguardp is_numeral(string) when string == "0" or
                                    string == "1" or
                                    string == "2" or
                                    string == "3" or
                                    string == "4" or
                                    string == "5" or
                                    string == "6" or
                                    string == "7" or
                                    string == "8" or
                                    string == "9"

  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(""), do: ""
  def encode(<<h::binary-size(1), rest::binary>>), do: encode(rest, "", {h, 1})

  defp encode("", result, acc), do: result <> serialize_acc(acc)
  defp encode(<<h::binary-size(1), rest::binary>>, result, {symbol, count}) when h == symbol, do: encode(rest, result, {symbol, count + 1})
  defp encode(<<h::binary-size(1), rest::binary>>, result, {symbol, count}) when h != symbol, do: encode(rest, result <> serialize_acc({symbol, count}), {h, 1})

  defp serialize_acc({symbol, 1}), do: symbol
  defp serialize_acc({symbol, count}), do: "#{count}#{symbol}"

  @spec decode(String.t()) :: String.t()
  def decode(string), do: decode(string, "", {nil, 0})

  defp decode("", result, _acc), do: result
  defp decode(<<h::binary-size(1), rest::binary>>, result, {_symbol, count}) when not is_numeral(h) and count == 0, do: decode(rest, result <> h, {nil, 0})
  defp decode(<<h::binary-size(1), rest::binary>>, result, {_symbol, count}) when not is_numeral(h) and count > 0, do: decode(rest, result <> repeat(h, count), {nil, 0})
  defp decode(<<h::binary-size(1), rest::binary>>, result, {symbol, count}) when is_numeral(h), do: decode(rest, result, {symbol, count * 10 + elem(Integer.parse(h, 10), 0)})
  defp decode(_string, _result, _acc), do: ""

  defp repeat(_string, count) when count < 1, do: ""
  defp repeat(string, count), do: string <> repeat(string, count - 1)
end
