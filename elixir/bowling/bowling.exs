defmodule Bowling do
  @max_frames_count 10
  @max_pins_count 10
  @min_pins_count 0
  @last_frame_num @max_frames_count - 1

  @type regular_frame ::
          :strike
          | {first_throw :: number, :spare}
          | {first_throw :: number, second_throw :: number}

  @type last_frame ::
          {:strike, second_throw :: number, third_throw :: number}
          | {first_throw :: number, :spare, third_throw :: number}
          | {first_throw :: number, second_throw :: number}

  @type frame :: regular_frame | last_frame

  @type game :: any

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  @spec start() :: game
  def start do
    {[], nil}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  @spec roll(any, integer) :: any | String.t()
  def roll({frames, _last_roll}, _roll) when length(frames) == @max_frames_count,
    do: {:error, "Cannot roll after game is over"}

  def roll(_game, roll) when roll < @min_pins_count, do: {:error, "Negative roll is invalid"}
  def roll(_game, roll) when roll > @max_pins_count, do: exceeded_pins_count()

  def roll({_frames, first_throw}, roll) when first_throw + roll > @max_pins_count,
    do: exceeded_pins_count()

  def roll({_frames, :strike, second_throw}, roll)
      when is_number(second_throw) and is_number(roll) and second_throw != @max_pins_count and
             second_throw + roll > @max_pins_count,
      do: exceeded_pins_count()

  def roll({frames, nil}, @max_pins_count) when length(frames) == @last_frame_num,
    do: {frames, :strike}

  def roll({frames, :strike}, roll) when length(frames) == @last_frame_num,
    do: {frames, :strike, roll}

  def roll({frames, :strike, second_roll}, roll) when length(frames) == @last_frame_num,
    do: {[{:strike, second_roll, roll} | frames], nil}

  def roll({frames, nil}, roll) when length(frames) == @last_frame_num, do: {frames, roll}

  def roll({frames, first_throw}, roll)
      when length(frames) == @last_frame_num and first_throw + roll == @max_pins_count,
      do: {frames, first_throw, :spare}

  def roll({frames, first_throw}, roll) when length(frames) == @last_frame_num,
    do: {[{first_throw, roll} | frames], nil}

  def roll({frames, first_throw, :spare}, roll) when length(frames) == @last_frame_num,
    do: {[{first_throw, :spare, roll} | frames], nil}

  def roll({frames, nil}, @max_pins_count), do: {[:strike | frames], nil}
  def roll({frames, nil}, roll), do: {frames, roll}

  def roll({frames, last_roll}, roll) when last_roll + roll == @max_pins_count,
    do: {[{last_roll, :spare} | frames], nil}

  def roll({frames, last_roll}, roll), do: {[{last_roll, roll} | frames], nil}

  defp exceeded_pins_count(), do: {:error, "Pin count exceeds pins on the lane"}

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(any) :: integer | String.t()
  def score({[], _last_roll}), do: not_end()
  def score({_frames, last_roll}) when not is_nil(last_roll), do: not_end()
  def score({_frames, _, _}), do: not_end()
  def score({frames, _last_roll}) when length(frames) != @max_frames_count, do: not_end()

  def score({frames, _last_roll}) do
    frames
    |> Enum.reverse()
    |> split_into_triples()
    |> Enum.map(&frame_points/1)
    |> Enum.sum()
  end

  defp not_end(), do: {:error, "Score cannot be taken until the end of the game"}

  defp split_into_triples([]), do: []
  defp split_into_triples([_h | t] = list), do: [Enum.take(list, 3) | split_into_triples(t)]

  defp frame_points([:strike, :strike, :strike]), do: @max_pins_count * 3
  defp frame_points([:strike, :strike, {:strike, _, _}]), do: @max_pins_count * 3
  defp frame_points([:strike, :strike, {first_throw, _}]), do: @max_pins_count * 2 + first_throw
  defp frame_points([:strike, {_first_throw, :spare}, _]), do: @max_pins_count * 2

  defp frame_points([:strike, {first_throw, second_throw}, _]),
    do: @max_pins_count + first_throw + second_throw

  defp frame_points([{_first_throw, :spare}, :strike, _]), do: @max_pins_count * 2

  defp frame_points([{_first_throw, :spare}, {next_first_throw, _}, _]),
    do: @max_pins_count + next_first_throw

  defp frame_points([{first_throw, second_throw}, _, _]), do: first_throw + second_throw

  defp frame_points([:strike, {:strike, second_throw, _}]), do: @max_pins_count * 2 + second_throw
  defp frame_points([:strike, {_first_throw, :spare, _}]), do: @max_pins_count * 2

  defp frame_points([:strike, {first_throw, second_throw, _}]),
    do: @max_pins_count + first_throw + second_throw

  defp frame_points([{_first_throw, :spare}, {:strike, _, _}]), do: @max_pins_count * 2

  defp frame_points([{_first_throw, :spare}, {next_first_throw, _, _}]),
    do: @max_pins_count + next_first_throw

  defp frame_points([{_first_throw, :spare}, {next_first_throw, _}]),
    do: @max_pins_count + next_first_throw

  defp frame_points([{first_throw, second_throw}, _]), do: first_throw + second_throw

  defp frame_points([{:strike, second_throw, third_throw}]),
    do: @max_pins_count + second_throw + third_throw

  defp frame_points([{_first_throw, :spare, third_throw}]), do: @max_pins_count + third_throw
  defp frame_points([{first_throw, second_throw}]), do: first_throw + second_throw

  defp frame_points([:strike]), do: @max_pins_count
  defp frame_points([{_first_throw, :spare}]), do: @max_pins_count
  defp frame_points([{first_throw, second_throw}]), do: first_throw + second_throw
end
