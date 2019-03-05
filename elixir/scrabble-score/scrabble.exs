defmodule Scrabble do
  @score_map %{
    ~W(A E I O U L N R S T) => 1,
    ~W(D G) => 2,
    ~W(B C M P) => 3,
    ~W(F H V W Y) => 4,
    ~W(K) => 5,
    ~W(J X) => 8,
    ~W(Q Z) => 10
  }

  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer
  def score(word) do
    word
    |> String.split("")
    |> Enum.map(&String.upcase/1)
    |> Enum.reduce(0, &(&2 + score_char(&1)))
  end

  defp score_char(char) do
    @score_map
    |> flat_score_map()
    |> Map.get(char, 0)
  end

  defp flat_score_map(map) do
    map
    |> Enum.flat_map(fn {keys, value} -> Enum.map(keys, fn key -> {key, value} end) end)
    |> Map.new()
  end
end
