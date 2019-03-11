defmodule Tournament do
  @outcomes ~W(win loss draw)

  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    input
    # parse input
    |> Enum.map(&String.split(&1, ";"))
    |> Enum.reduce(%{}, &parse_line/2)
    # format result
    |> Map.to_list()
    |> Enum.sort_by(fn {_name, map} -> map.points end, &Kernel.>=/2)
    |> Enum.map(&format_team_results/1)
    |> prepend_header()
    |> Enum.join("\n")
  end

  @won_default %{played: 1, won: 1, drawn: 0, lost: 0, points: 3}
  @lost_default %{played: 1, won: 0, drawn: 0, lost: 1, points: 0}
  @draw_default %{played: 1, won: 0, drawn: 1, lost: 0, points: 1}

  defp value_merge(_key, value1, value2), do: value1 + value2
  defp map_merge(map, default), do: Map.merge(map, default, &value_merge/3)

  defp won_update(map), do: map_merge(map, @won_default)
  defp lost_update(map), do: map_merge(map, @lost_default)
  defp drawn_update(map), do: map_merge(map, @draw_default)

  defp parse_line([player1, player2, outcome], acc) when outcome in @outcomes do
    case outcome do
      "win" ->
        acc
        |> Map.update(player1, @won_default, &won_update/1)
        |> Map.update(player2, @lost_default, &lost_update/1)

      "loss" ->
        acc
        |> Map.update(player1, @lost_default, &lost_update/1)
        |> Map.update(player2, @won_default, &won_update/1)

      "draw" ->
        acc
        |> Map.update(player1, @draw_default, &drawn_update/1)
        |> Map.update(player2, @draw_default, &drawn_update/1)
    end
  end

  defp parse_line(_, acc), do: acc

  defp format_points(points) when is_bitstring(points), do: String.pad_leading(points, 2)

  defp format_points(points) when is_integer(points) do
    points
    |> Integer.to_string()
    |> format_points()
  end

  defp format_row(team, points) do
    Enum.join([String.pad_trailing(team, 30) | Enum.map(points, &format_points/1)], " | ")
  end

  defp format_team_results(
         {name, %{played: played, won: won, drawn: drawn, lost: lost, points: points}}
       ) do
    format_row(name, [played, won, drawn, lost, points])
  end

  defp prepend_header(results), do: [format_row("Team", ["MP", "W", "D", "L", "P"]) | results]
end
