defmodule AllYourBase do
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: list
  def convert(digits, base_a, base_b) when digits == [] or base_a < 2 or base_b < 2, do: nil

  def convert(digits, base_a, base_b) do
    digits_length = length(digits) - 1

    case digits_valid?(digits, base_a) do
      true ->
        digits
        |> Enum.with_index()
        |> Enum.map(fn {value, index} -> {value, digits_length - index} end)
        |> Enum.map(fn {value, power} -> round(value * :math.pow(base_a, power)) end)
        |> Enum.sum()
        |> digits_of_base(base_b)

      false ->
        nil
    end
  end

  defp digits_valid?(digits, base), do: Enum.all?(digits, &(&1 < base and &1 >= 0))

  def digits_of_base(number, base, acc \\ [])
  def digits_of_base(0, _base, []), do: [0]
  def digits_of_base(0, _base, digits), do: digits

  def digits_of_base(number, _base, _digits) when number < 0,
    do: raise("Number is less than zero")

  def digits_of_base(number, base, digits) do
    number
    |> Integer.floor_div(base)
    |> digits_of_base(base, [rem(number, base) | digits])
  end
end
