defmodule PigLatin do
  @vowels 'aeiou'

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
  def translate_word([?q|[?u|letters]]), do: [letters | 'quay']
  def translate_word([?s|[?q|[?u|letters]]]), do: [letters | 'squay']
  def translate_word([a|[b|letters]]) when a in 'xy' and b not in @vowels, do: [[a|[b|letters]] | 'ay']

  def translate_word(letters) do
    consonants = Enum.take_while(letters, fn letter -> !Enum.member?(@vowels, letter) end)
    [[Enum.drop(letters, length(consonants)) | consonants] | 'ay']
  end

  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split(" ")
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&translate_word/1)
    |> Enum.join(" ")
  end
end
