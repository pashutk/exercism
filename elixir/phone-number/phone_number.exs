defmodule Phone do
  @default_invalid "0000000000"

  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("212-555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 055-0100")
  "0000000000"

  iex> Phone.number("(212) 555-0100")
  "2125550100"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t()) :: String.t()
  def number(raw) do
    raw
    |> check_wrong_symbols()
    |> String.split(~r/[^\d]/, trim: true)
    |> Enum.join()
    |> parse()
  end

  defp check_wrong_symbols(string) do
    cond do
      String.match?(string, ~r/^[\d\(\)\+\-\s\.]+$/) -> string
      true -> ""
    end
  end

  defp parse("1" <> rest), do: parse(rest)

  defp parse(<<n_1::binary-size(1), _::binary-size(2), n_2::binary-size(1)>> <> _ = string)
       when byte_size(string) === 10 and n_1 not in ~W(0 1) and n_2 not in ~W(0 1),
       do: string

  defp parse(_string), do: @default_invalid

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("212-555-0100")
  "212"

  iex> Phone.area_code("+1 (212) 555-0100")
  "212"

  iex> Phone.area_code("+1 (012) 555-0100")
  "000"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t()) :: String.t()
  def area_code(raw) do
    raw
    |> number()
    |> String.slice(0..2)
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("212-555-0100")
  "(212) 555-0100"

  iex> Phone.pretty("212-155-0100")
  "(000) 000-0000"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t()) :: String.t()
  def pretty(raw) do
    <<area::binary-size(3), base_1::binary-size(3), base_2::binary>> = number(raw)
    "(#{area}) #{base_1}-#{base_2}"
  end
end
