defmodule LinkedList do
  @opaque t :: tuple()

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new(), do: {:root, nil}

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push({value, next}, elem), do: {value, {elem, next}}

  @doc """
  Calculate the length of a LinkedList
  """
  @spec length(t) :: non_neg_integer()
  def length({_value, nil}), do: 0
  def length({_value, next}), do: 1 + LinkedList.length(next)

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?({_value, next}), do: next == nil

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek({:root, nil}), do: {:error, :empty_list}
  def peek({:root, {value, _next}}), do: {:ok, value}

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail({:root, nil}), do: {:error, :empty_list}
  def tail({:root, {_value, next}}), do: {:ok, {:root, next}}

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop({:root, nil}), do: {:error, :empty_list}
  def pop(list), do: {:ok, elem(LinkedList.peek(list), 1), elem(LinkedList.tail(list), 1)}

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list, acc \\ LinkedList.new())
  def from_list([], acc), do: acc
  def from_list([h | t], acc), do: LinkedList.push(LinkedList.from_list(t, acc), h)

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(list) do
    case LinkedList.pop(list) do
      {:ok, elem, tail} -> [elem | to_list(tail)]
      {:error, _} -> []
    end
  end

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list, acc \\ LinkedList.new()) do
    case LinkedList.pop(list) do
      {:ok, elem, tail} -> reverse(tail, LinkedList.push(acc, elem))
      {:error, _} -> acc
    end
  end
end
