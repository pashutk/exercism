defmodule BracketPush do
  @supported_bracket_pairs [{"[", "]"}, {"{", "}"}, {"(", ")"}]

  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str, stack \\ [])

  @supported_bracket_pairs
  |> Enum.each(fn {open_bracket, close_bracket} ->
    def check_brackets(unquote(open_bracket) <> tail, stack) do
      check_brackets(tail, [unquote(open_bracket) | stack])
    end

    def check_brackets(unquote(close_bracket) <> tail, [unquote(open_bracket) | t]) do
      check_brackets(tail, t)
    end

    def check_brackets(unquote(close_bracket) <> _, _), do: false
  end)

  def check_brackets(<<_::utf8>> <> tail, stack), do: check_brackets(tail, stack)

  def check_brackets("", []), do: true
  def check_brackets("", _), do: false
end
