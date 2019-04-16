defmodule CustomSet do
  @opaque t :: %__MODULE__{map: map}

  defstruct map: %{}

  defguardp empty_map?(map) when map == %{}

  @spec new(Enum.t()) :: t
  def new(enumerable) do
    %__MODULE__{map: Map.new(enumerable, &{&1, &1})}
  end

  @spec empty?(t) :: boolean
  def empty?(%{map: map}) when empty_map?(map), do: true
  def empty?(_), do: false

  @spec contains?(t, any) :: boolean
  def contains?(%{map: map}, element), do: Map.has_key?(map, element)

  @spec subset?(t, t) :: boolean
  def subset?(%{map: map1}, custom_set_2) do
    Map.keys(map1)
    |> Enum.all?(&contains?(custom_set_2, &1))
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(custom_set_1, custom_set_2) do
    intersection(custom_set_1, custom_set_2)
    |> empty?()
  end

  @spec equal?(t, t) :: boolean
  def equal?(%{map: map1}, %{map: map2}), do: Map.equal?(map1, map2)

  @spec add(t, any) :: t
  def add(%{map: map1}, element), do: %__MODULE__{map: Map.put(map1, element, element)}

  @spec intersection(t, t) :: t
  def intersection(%{map: map1}, custom_set_2) do
    Map.keys(map1)
    |> Enum.filter(&contains?(custom_set_2, &1))
    |> new()
  end

  @spec difference(t, t) :: t
  def difference(%{map: map1}, custom_set_2) do
    Map.keys(map1)
    |> Enum.filter(fn x -> not contains?(custom_set_2, x) end)
    |> new()
  end

  @spec union(t, t) :: t
  def union(%{map: map1}, %{map: map2}), do: %__MODULE__{map: Map.merge(map1, map2)}
end
