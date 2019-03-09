defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence, acc \\ MapSet.new())
  def isogram?("", acc), do: MapSet.size(acc) != 0

  def isogram?(<<sym::utf8>> <> sentence, acc) when sym in ?A..?Z,
    do: isogram?(String.downcase(<<sym>>) <> sentence, acc)

  def isogram?(<<sym::utf8>> <> sentence, acc) when sym in ?a..?z do
    case MapSet.member?(acc, sym) do
      true -> false
      false -> isogram?(sentence, MapSet.put(acc, sym))
    end
  end

  def isogram?(<<_sym::utf8>> <> sentence, acc), do: isogram?(sentence, acc)
end
