defmodule Aoc2024.Day6 do
  def part1() do
    board = get_board()

    starting_point = find_start_location(board)

    simulate(starting_point, board, []) |> Enum.uniq() |> length()
  end

  defp simulate({y, x, dir}, board, visited) do
    visited = visited ++ [{y, x}]
    IO.inspect(visited)
    {dy, dx} = lookup_movement(dir)
    new_char = board[y + dy][x + dx]

    cond do
      is_nil(new_char) ->
        visited

      new_char == "#" ->
        new_dir = rotate_dir(dir)
        simulate({y, x, new_dir}, board, visited)

      true ->
        simulate({y + dy, x + dx, dir}, board, visited)
    end
  end

  defp rotate_dir("<"), do: "^"
  defp rotate_dir("^"), do: ">"
  defp rotate_dir("v"), do: "<"
  defp rotate_dir(">"), do: "v"

  defp lookup_movement("<"), do: {0, -1}
  defp lookup_movement("^"), do: {-1, 0}
  defp lookup_movement("v"), do: {1, 0}
  defp lookup_movement(">"), do: {0, 1}

  def get_board() do
    Aoc2024.get_file_lines("./input/day6.txt")
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      {y,
       line
       |> String.split("", trim: true)
       |> Enum.with_index()
       |> Enum.map(fn {val, x} -> {x, val} end)
       |> Map.new()}
    end)
    |> Map.new()
  end

  defp find_start_location(board) do
    Enum.find_value(board, fn {y, row} ->
      {x, dir} =
        Enum.find(row, {nil, nil}, fn {x, val} ->
          val in ~w[^ < > v]
        end)

      if !is_nil(x), do: {y, x, dir}, else: false
    end)
  end
end
