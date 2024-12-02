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
end
