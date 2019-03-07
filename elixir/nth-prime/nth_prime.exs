defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count < 1, do: raise("U mad bro")
  def nth(1), do: 2
  def nth(count) do
    count - 1
    |> nth()
    |> next_prime()
  end

  @spec nth(non_neg_integer) :: non_neg_integer
  def next_prime(start) when start < 2, do: 2
  def next_prime(start) do
    start + 1..start * 2
    |> Stream.filter(&(rem(&1, 2) != 0))
    |> Stream.filter(&(prime?(&1) == true))
    |> Enum.take(1)
    |> hd()
  end

  @spec nth(non_neg_integer) :: boolean
  def prime?(value) when value < 2, do: false
  def prime?(2), do: true
  def prime?(value) do
    2..value - 1
    |> Stream.filter(&(rem(&1, 2) != 0))
    |> Stream.drop_while(&rem(value, &1) != 0)
    |> Enum.empty?()
  end
end
