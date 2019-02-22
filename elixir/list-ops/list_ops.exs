defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: count_p(l, 0)

  defp count_p([_h | t], acc), do: count_p(t, acc + 1)
  defp count_p([], acc), do: acc

  @spec reverse(list) :: list
  def reverse(l), do: reverse_p(l, [])

  defp reverse_p([h | t], acc), do: reverse_p(t, [h | acc])
  defp reverse_p([], acc), do: acc

  @spec map(list, (any -> any)) :: list
  def map([h | t], f), do: [f.(h) | map(t, f)]
  def map([], f), do: []

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([h | t], f), do: (cond do
    f.(h) -> [h | filter(t, f)]
    true -> filter(t, f)
  end)
  def filter([], _f), do: []

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([h | t], acc, f), do: reduce(t, f.(h, acc), f)
  def reduce([], acc, _f), do: acc

  @spec append(list, list) :: list
  def append([h | t], b), do: [h | append(t, b)]
  def append([], b), do: b

  @spec concat([[any]]) :: [any]
  def concat(ll), do: ll |> reverse |> reduce([], &append/2)
end
