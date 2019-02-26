defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate("a" <> rest), do: "a#{rest}ay"
  def translate("e" <> rest), do: "e#{rest}ay"
  def translate("i" <> rest), do: "i#{rest}ay"
  def translate("o" <> rest), do: "o#{rest}ay"
  def translate("u" <> rest), do: "u#{rest}ay"
  def translate("yt" <> rest), do: "yt#{rest}ay"
  def translate("xr" <> rest), do: "xr#{rest}ay"

  def translate("xr" <> rest), do: "xr#{rest}ay"
  def translate("b" <> rest), do: ""
  def translate("c" <> rest), do: ""
  def translate("d" <> rest), do: ""
  def translate("f" <> rest), do: ""
  def translate("g" <> rest), do: ""
  def translate("h" <> rest), do: ""
  def translate("j" <> rest), do: ""
  def translate("k" <> rest), do: ""
  def translate("l" <> rest), do: ""
  def translate("m" <> rest), do: ""
  def translate("n" <> rest), do: ""
  def translate("p" <> rest), do: ""
  def translate("q" <> rest), do: ""
  def translate("r" <> rest), do: ""
  def translate("s" <> rest), do: ""
  def translate("t" <> rest), do: ""
  def translate("v" <> rest), do: ""
  def translate("x" <> rest), do: ""
  def translate("y" <> rest), do: ""
  def translate("z" <> rest), do: ""
  # def translate(<<consonant::bytes-size(1)>> <> rest), do: "#{rest}#{consonant}ay"


  def translate(phrase) do
    case phrase do
      true -> ""
    end
  end
end
