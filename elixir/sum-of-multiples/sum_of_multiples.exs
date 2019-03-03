defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors, acc \\ 0)
  def to(0, _factors, acc), do: acc

  def to(limit, factors, acc) do
    to(
      limit - 1,
      factors,
      Enum.reduce_while(factors, acc, fn val, acc ->
        case rem(limit - 1, val) do
          0 -> {:halt, acc + limit - 1}
          _ -> {:cont, acc}
        end
      end)
    )
  end
end
