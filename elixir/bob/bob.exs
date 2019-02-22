defmodule Bob do
  def contains_letter?(string), do: String.upcase(string) != String.downcase(string)

  def shouting?(input), do: contains_letter?(input) and String.upcase(input) === input

  def asking?(input), do: String.ends_with?(input, "?")

  def hey(input) do
    cond do
      # silence
      String.trim(input) == "" -> "Fine. Be that way!"

      # asking in capitals
      shouting?(input) and asking?(input) -> "Calm down, I know what I'm doing!"

      # shouting
      shouting?(input) -> "Whoa, chill out!"

      # asking a question
      asking?(input) -> "Sure."

      # stating something
      true -> "Whatever."
    end
  end
end
