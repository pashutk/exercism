defmodule RotationalCipher do
  @uppercase_first ?A
  @lowercase_first ?a
  @alphabet_size ?z - ?a + 1

  def calculate_shifted_char(char, shift, first_char) do
    first_char + rem char - first_char + shift, @alphabet_size
  end

  def is_uppercase?(char) do
    char >= @uppercase_first and char < @uppercase_first + @alphabet_size
  end

  def is_lowercase?(char) do
    char >= @lowercase_first and char < @lowercase_first + @alphabet_size
  end

  def calculate_shifted_char(char, shift) do
    calculate_shifted_char_from = &(calculate_shifted_char(char, shift, &1))

    cond do
      is_uppercase? char -> calculate_shifted_char_from.(@uppercase_first)
      is_lowercase? char -> calculate_shifted_char_from.(@lowercase_first)
      true -> char
    end
  end

  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    to_string Enum.map String.to_charlist(text), fn char -> calculate_shifted_char(char, shift) end
  end
end
