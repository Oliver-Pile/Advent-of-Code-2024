defmodule Aoc2024.Day4 do
  # I cant take credit for part 1. It was copied from https://github.com/irondeau/advent_of_code/blob/master/lib/2024/04_ceres_search.ex.
  def part1() do
    word_map = get_word_map()

    for y <- 0..(map_size(word_map) - 1), x <- 0..(map_size(word_map[y]) - 1) do
      find_count(word_map, {x, y})
    end
    |> Enum.sum()
  end

  defp find_count(map, {x, y}, [char | rest] \\ ~w[X M A S]) do
    if map[y][x] == char do
      [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}]
      |> Enum.map(fn {dx, dy} ->
        check_run(map, {x + dx, y + dy}, rest, {dx, dy})
      end)
      |> Enum.sum()
    else
      0
    end
  end

  defp check_run(map, {x, y}, ["S"], _dxdy) do
    if map[y][x] == "S", do: 1, else: 0
  end

  defp check_run(map, {x, y}, [char | rest], {dx, dy}) do
    if map[y][x] == char do
      check_run(map, {x + dx, y + dy}, rest, {dx, dy})
    else
      0
    end
  end

  defp get_word_map() do
    Aoc2024.get_file_lines("./input/day4.txt")
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      {y,
       line
       |> String.graphemes()
       |> Enum.with_index()
       |> Enum.map(fn {char, x} -> {x, char} end)
       |> Map.new()}
    end)
    |> Map.new()
  end
end
