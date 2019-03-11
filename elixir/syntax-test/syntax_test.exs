ExUnit.start()
ExUnit.configure(trace: true, exclude: :pending)

defmodule SyntaxTest do
  use ExUnit.Case

  test "one" do


    assert Tournament.tally(input) == expected
  end
end
