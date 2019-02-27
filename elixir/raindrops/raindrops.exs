defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    words = raindrop(number)

    case words do
      [] -> Integer.to_string(number)
      _ -> Enum.join(words)
    end
  end

  defp conv(number, factor, string) when rem(number, factor) == 0, do: [string]
  defp conv(_number, _factor, _string), do: []

  defp raindrop(number), do: [] ++ conv_3(number) ++ conv_5(number) ++ conv_7(number)

  defp conv_3(number), do: conv(number, 3, "Pling")
  defp conv_5(number), do: conv(number, 5, "Plang")
  defp conv_7(number), do: conv(number, 7, "Plong")
end
