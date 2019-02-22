defmodule Strain do
  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun) do
    process(true, list, fun, [])
  end

  @spec process(keep :: boolean, list(any), fun :: (any -> boolean), acc :: list(any)) :: list()
  defp process(keep, [h | t], fun, acc) do
    process(keep, t, fun, cond do
      fun.(h) == keep -> acc ++ [h]
      true -> acc
    end)
  end

  defp process(_keep, [], _fun, acc), do: acc

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun) do
    process(false, list, fun, [])
  end
end
