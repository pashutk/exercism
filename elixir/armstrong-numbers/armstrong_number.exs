defmodule ArmstrongNumber do
  @base 10

  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """
  @spec is_valid?(integer) :: boolean
  def is_valid?(number) do
    number
    |> split()
    |> sum_powers()
    |> Kernel.==(number)
  end

  defp split(number, acc \\ [])
  defp split(0, acc), do: acc
  defp split(number, acc), do: split(div(number, @base), [rem(number, @base) | acc])

  defp sum_powers(list), do: sum_powers(list, length(list))
  defp sum_powers([h | t], power), do: :math.pow(h, power) + sum_powers(t, power)
  defp sum_powers([], _power), do: 0
end
