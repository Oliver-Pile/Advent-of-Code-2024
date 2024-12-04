defmodule Aoc2024.Day4 do
  # I cant take credit for part 1. It was copied from https://github.com/irondeau/advent_of_code/blob/master/lib/2024/04_ceres_search.ex. (After long consideration, pondering and experimentation)
  def part1() do
    word_map = get_word_map()

    # For each combination of x/y see if its a valid word
    for y <- 0..(map_size(word_map) - 1), x <- 0..(map_size(word_map[y]) - 1) do
      find_count(word_map, {x, y})
    end
    |> Enum.sum()
  end

  defp find_count(map, {x, y}, [char | rest] \\ ~w[X M A S]) do
    # If character at x,y is X then start the lookup
    if map[y][x] == char do
      # For each of the directions (+/-), recursively check the remaing characters
      [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}]
      |> Enum.map(fn {dx, dy} ->
        check_run(map, {x + dx, y + dy}, rest, {dx, dy})
      end)
      |> Enum.sum()
    else
      0
    end
  end

  # If the final letter 'S' has been found then the word XMAS is there.
  defp check_run(map, {x, y}, ["S"], _dxdy) do
    if map[y][x] == "S", do: 1, else: 0
  end

  # Entry for the recursive lookup along one specific axis.
  defp check_run(map, {x, y}, [char | rest], {dx, dy}) do
    if map[y][x] == char do
      check_run(map, {x + dx, y + dy}, rest, {dx, dy})
    else
      0
    end
  end

  # Whilst part 2 was my own design, it obviously uses some of the logic from part 1 so see the repo linked there.
  def part2() do
    word_map = get_word_map()

    # For each combination of x/y, check if valid X
    for y <- 0..(map_size(word_map) - 1), x <- 0..(map_size(word_map[y]) - 1) do
      find_count_2(word_map, {x, y})
    end
    |> Enum.sum()
  end

  # Start at the middle of the X, then check each diagonal. For the diagonal, make sure both characters are correct
  defp find_count_2(map, {x, y}) do
    with "A" <- map[y][x],
         ["M", "S"] <- Enum.sort([map[y + 1][x + 1], map[y - 1][x - 1]]),
         ["M", "S"] <- Enum.sort([map[y + 1][x - 1], map[y - 1][x + 1]]) do
      1
    else
      _ -> 0
    end
  end

  # Create a map (dictionary) which links x/y positions and characters
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
