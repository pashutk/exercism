defmodule BracketPush do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str, stack \\ [])
  def check_brackets("[" <> tail, stack), do: check_brackets(tail, ["[" | stack])
  def check_brackets("]" <> tail, ["[" | t]), do: check_brackets(tail, t)
  def check_brackets("]" <> _, _), do: false

  def check_brackets("{" <> tail, stack), do: check_brackets(tail, ["{" | stack])
  def check_brackets("}" <> tail, ["{" | t]), do: check_brackets(tail, t)
  def check_brackets("}" <> _, _), do: false

  def check_brackets("(" <> tail, stack), do: check_brackets(tail, ["(" | stack])
  def check_brackets(")" <> tail, ["(" | t]), do: check_brackets(tail, t)
  def check_brackets(")" <> _, _), do: false

  def check_brackets(<<_::utf8>> <> tail, stack), do: check_brackets(tail, stack)

  def check_brackets("", []), do: true
  def check_brackets("", _), do: false
end
