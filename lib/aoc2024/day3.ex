defmodule Aoc2024.Day3 do
  def part1() do
    Aoc2024.get_file_lines("./input/day3.txt")
    |> Enum.map(fn line ->
      Regex.scan(~r/mul\((\d+),(\d+)\)/, line, capture: :all_but_first)
      |> Enum.map(fn [x,y] ->
        String.to_integer(x) * String.to_integer(y)
      end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end
end
