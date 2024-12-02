defmodule Aoc2024.Day2 do
  def part1() do
    Aoc2024.get_file_lines("./input/day2.txt")
    |> Enum.map(fn line ->
      String.split(line, ~r/\s+/) |> Enum.map(&String.to_integer/1)
    end)
    |> check_all_increasing_decreasing()
    |> check_differences()
    |> length()
  end

  defp check_all_increasing_decreasing(lines) do
    Enum.filter(lines, fn line ->
      sorted = Enum.sort(line)

      line == sorted or line == Enum.reverse(sorted)
    end)
  end

  defp check_differences(lines) do
    Enum.filter(lines, fn line ->
      Enum.chunk_every(line, 2, 1, :discard)
      |> Enum.map(fn [x, y] ->
        abs(x - y)
      end)
      |> Enum.all?(&(&1 >= 1 and &1 <= 3))
    end)
  end

  # Initial thinking was to go through and first alter the list of levels to remove any with issues.
  def part2() do
    lines =
      Aoc2024.get_file_lines("./input/test.txt")
      |> Enum.map(fn line ->
        String.split(line, ~r/\s+/) |> Enum.map(&String.to_integer/1)
      end)

    Enum.map(lines, fn line ->
      chunked = Enum.chunk_every(line, 2, 1, :discard)
      dir = check_dir(chunked)

      {removed?, new_line} =
        check_direction_maybe_remove(line, chunked, dir) |> IO.inspect(charlists: :as_lists)

      if removed? do
        new_line
      else
        check_differences_and_maybe_remove(new_line)
      end
    end)
    |> IO.inspect(charlists: :as_lists)
    |> check_all_increasing_decreasing()
    |> check_differences()
    |> length()
  end

  defp check_differences_and_maybe_remove(new_line) do
    Enum.chunk_every(new_line, 2, 1, :discard)
    |> Enum.find_index(fn [x, y] ->
      diff = abs(y - x)
      diff < 1 or diff > 3
    end)
    |> case do
      nil -> new_line
      index -> List.delete_at(new_line, index + 1)
    end
  end

  defp check_direction_maybe_remove(line, chunked, :asc) do
    chunked
    |> Enum.find_index(fn [x, y] ->
      y < x
    end)
    |> case do
      nil -> {false, line}
      index -> {true, List.delete_at(line, index)}
    end
  end

  defp check_direction_maybe_remove(line, chunked, :desc) do
    chunked
    |> Enum.find_index(fn [x, y] ->
      y > x
    end)
    |> case do
      nil -> {false, line}
      index -> {true, List.delete_at(line, index)}
    end
  end

  defp check_dir(chunked) do
    diffs =
      chunked
      |> Enum.map(fn [x, y] ->
        y - x
      end)

    incr = Enum.count(diffs, &(&1 > 0))
    decr = Enum.count(diffs, &(&1 < 0))

    if incr > decr, do: :asc, else: :desc
  end
end
