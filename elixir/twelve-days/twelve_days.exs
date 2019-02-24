defmodule TwelveDays do
  @gifts {
    "a Partridge in a Pear Tree",
    "two Turtle Doves",
    "three French Hens",
    "four Calling Birds",
    "five Gold Rings",
    "six Geese-a-Laying",
    "seven Swans-a-Swimming",
    "eight Maids-a-Milking",
    "nine Ladies Dancing",
    "ten Lords-a-Leaping",
    "eleven Pipers Piping",
    "twelve Drummers Drumming"
  }

  @numerals {
    "first",
    "second",
    "third",
    "fourth",
    "fifth",
    "sixth",
    "seventh",
    "eighth",
    "ninth",
    "tenth",
    "eleventh",
    "twelfth"
  }

  defp elem_or(tuple, index, _default) when index >= 0 and index < tuple_size(tuple), do: elem(tuple, index)
  defp elem_or(_tuple, _index, default), do: default

  defp elem_or_empty_string(tuple, index), do: elem_or(tuple, index, "")

  defp gifts(1), do: elem_or_empty_string(@gifts, 0)
  defp gifts(2), do: "#{elem_or_empty_string(@gifts, 1)}, and #{elem_or_empty_string(@gifts, 0)}"
  defp gifts(number), do: "#{elem_or_empty_string(@gifts, number - 1)}, #{gifts(number - 1)}"

  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(number), do: "On the #{elem_or_empty_string(@numerals, number - 1)} day of Christmas my true love gave to me: #{gifts(number)}."

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) when starting_verse == ending_verse, do: verse(starting_verse)
  def verses(starting_verse, ending_verse), do: "#{verse(starting_verse)}\n" <> verses(starting_verse + 1, ending_verse)

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing, do: verses(1, 12)
end
