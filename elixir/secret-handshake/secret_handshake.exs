defmodule SecretHandshake do
  use Bitwise

  @checks [
    [0b1, "wink"],
    [0b10, "double blink"],
    [0b100, "close your eyes"],
    [0b1000, "jump"]
  ]

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    list = Enum.reduce(@checks, [], fn ([ref, word], acc) -> cond do
      (code &&& ref) > 0 -> acc ++ [word]
      true -> acc
    end end)

    cond do
      (0b10000 &&& code) > 0 -> Enum.reverse(list)
      true -> list
    end
  end
end
