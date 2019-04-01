defmodule Forth do
  defmodule Stack do
    def new(), do: []

    def push(stack, value), do: [value | stack]

    def pop([]), do: raise(Forth.StackUnderflow)
    def pop([value | stack]), do: {stack, value}

    def top(stack), do: pop(stack) |> elem(1)

    def drop(stack), do: pop(stack) |> elem(0)

    def format([]), do: ""

    def format(stack) do
      stack
      |> Enum.reverse()
      |> Enum.join(" ")
    end
  end

  @lexer_regexp ~r/:.+?[\w-]+.+?;|\d+|[\w\p{Sc}-]+|[+*\/-]/u

  @opaque evaluator :: Evaluator

  defmodule Evaluator do
    defstruct ops: Map.new(), stack: Stack.new()

    def new(), do: %Evaluator{}

    def wrapper_for_eval_binary(function) do
      fn ev ->
        {new_stack, b} = Stack.pop(ev.stack)
        {new_stack, a} = Stack.pop(new_stack)
        %{ev | stack: Stack.push(new_stack, function.(a, b))}
      end
    end

    def add_op(ev, operator, ev_wrapper), do: %{ev | ops: Map.put(ev.ops, operator, ev_wrapper)}

    def eval_token(ev, token) do
      upcase_token = String.upcase(token)

      cond do
        # registered opcode
        Map.has_key?(ev.ops, upcase_token) ->
          Map.get(ev.ops, upcase_token).(ev)

        # define new word
        Regex.match?(~r/^: (.+?) (.+?) ;$/u, token) ->
          [[_full_match, name, value]] = Regex.scan(~r/^: (.+?) (.+?) ;$/u, token)

          if Regex.match?(~r/^\d+$/, name) do
            raise Forth.InvalidWord
          end

          %{ev | ops: Map.put(ev.ops, String.upcase(name), fn ev -> Forth.eval(ev, value) end)}

        # number
        Regex.match?(~r/^\d+$/u, token) ->
          %{ev | stack: Stack.push(ev.stack, String.to_integer(token))}

        # anything else
        true ->
          raise Forth.UnknownWord
      end
    end
  end

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    Evaluator.new()
    |> Evaluator.add_op("+", Evaluator.wrapper_for_eval_binary(fn a, b -> a + b end))
    |> Evaluator.add_op("-", Evaluator.wrapper_for_eval_binary(fn a, b -> a - b end))
    |> Evaluator.add_op("*", Evaluator.wrapper_for_eval_binary(fn a, b -> a * b end))
    |> Evaluator.add_op(
      "/",
      Evaluator.wrapper_for_eval_binary(fn
        _a, 0 -> raise Forth.DivisionByZero
        a, b -> div(a, b)
      end)
    )
    |> Evaluator.add_op("DUP", fn ev ->
      %{ev | stack: Stack.push(ev.stack, Stack.top(ev.stack))}
    end)
    |> Evaluator.add_op("DROP", fn ev -> %{ev | stack: Stack.drop(ev.stack)} end)
    |> Evaluator.add_op("SWAP", fn ev ->
      {new_stack, top} = Stack.pop(ev.stack)
      {new_stack, bottom} = Stack.pop(new_stack)
      new_stack = Stack.push(new_stack, top)
      %{ev | stack: Stack.push(new_stack, bottom)}
    end)
    |> Evaluator.add_op("OVER", fn ev ->
      {new_stack, _top} = Stack.pop(ev.stack)
      %{ev | stack: Stack.push(ev.stack, Stack.top(new_stack))}
    end)
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    Regex.scan(@lexer_regexp, s)
    |> Enum.flat_map(& &1)
    |> Enum.reduce(ev, &Evaluator.eval_token(&2, &1))
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev), do: Stack.format(ev.stack)

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
