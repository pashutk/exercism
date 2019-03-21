defmodule BinTree do
  import Inspect.Algebra

  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """
  @type t :: %BinTree{value: any, left: BinTree.t() | nil, right: BinTree.t() | nil}
  defstruct [:value, :left, :right]

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BinTree[value: 3, left: BinTree[value: 5, right: BinTree[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: value, left: left, right: right}, opts) do
    concat([
      "(",
      to_doc(value, opts),
      ":",
      if(left, do: to_doc(left, opts), else: ""),
      ":",
      if(right, do: to_doc(right, opts), else: ""),
      ")"
    ])
  end
end

defmodule Zipper do
  @type t :: {}

  defp bt(value, left, right), do: %BinTree{value: value, left: left, right: right}
  defp bt({value, left, right}), do: %BinTree{value: value, left: left, right: right}

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree), do: {[], {bin_tree.value, bin_tree.left, bin_tree.right}}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree({[], {value, left, right}}), do: bt(value, left, right)

  def to_tree({[{:left, step_value, step_right} | trail], {value, left, right}}) do
    to_tree({trail, {step_value, bt(value, left, right), step_right}})
  end

  def to_tree({[{:right, step_value, step_left} | trail], {value, left, right}}) do
    to_tree({trail, {step_value, step_left, bt(value, left, right)}})
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value({_trail, {value, _left, _right}}), do: value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left({_trail, {_value, nil, _right}}), do: nil

  def left({trail, {value, left, right}}) do
    {[{:left, value, right} | trail], {left.value, left.left, left.right}}
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right({_trail, {_value, _left, nil}}), do: nil

  def right({trail, {value, left, right}}) do
    {[{:right, value, left} | trail], {right.value, right.left, right.right}}
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up({[], _cursor}), do: nil

  def up({[{:left, step_value, step_right} | trail], cursor}),
    do: {trail, {step_value, bt(cursor), step_right}}

  def up({[{:right, step_value, step_left} | trail], cursor}),
    do: {trail, {step_value, step_left, bt(cursor)}}

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value({trail, {_value, left, right}}, new_value), do: {trail, {new_value, left, right}}

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left({trail, {value, _left, right}}, new_left), do: {trail, {value, new_left, right}}

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right({trail, {value, left, _right}}, new_right), do: {trail, {value, left, new_right}}
end
