defmodule RobotSimulator do
  @valid_directions [:north, :east, :south, :west]

  defstruct direction: :north, position: {0, 0}

  defguardp is_unvalid_position(position)
            when not is_tuple(position) or tuple_size(position) != 2 or
                   not is_number(elem(position, 0)) or not is_number(elem(position, 1))

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, _position) when direction not in @valid_directions,
    do: {:error, "invalid direction"}

  def create(_direction, position) when is_unvalid_position(position),
    do: {:error, "invalid position"}

  def create(direction, position), do: %RobotSimulator{direction: direction, position: position}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, ""), do: robot

  def simulate(robot, "R" <> instructions) do
    Map.update!(robot, :direction, fn current_direction ->
      case current_direction do
        :north -> :east
        :west -> :north
        :south -> :west
        :east -> :south
      end
    end)
    |> simulate(instructions)
  end

  def simulate(robot, "L" <> instructions) do
    Map.update!(robot, :direction, fn current_direction ->
      case current_direction do
        :north -> :west
        :west -> :south
        :south -> :east
        :east -> :north
      end
    end)
    |> simulate(instructions)
  end

  def simulate(robot, "A" <> instructions) do
    Map.update!(robot, :position, fn {pos_x, pos_y} ->
      case robot.direction do
        :north -> {pos_x, pos_y + 1}
        :west -> {pos_x - 1, pos_y}
        :south -> {pos_x, pos_y - 1}
        :east -> {pos_x + 1, pos_y}
      end
    end)
    |> simulate(instructions)
  end

  def simulate(_robot, _instructions), do: {:error, "invalid instruction"}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%{direction: d}), do: d

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(%{position: p}), do: p
end
