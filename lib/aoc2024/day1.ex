defmodule Aoc2024.Day1 do
  def part1() do
    {left, right} = extract_lists()

    sorted_left = Enum.sort(left)
    sorted_right = Enum.sort(right)

    Enum.zip(sorted_left, sorted_right)
    |> Enum.map(fn {left, right} ->
      abs(left - right)
    end)
    |> Enum.sum()
  end

  defp extract_lists() do
    Aoc2024.get_file_lines("./input/day1.txt")
    |> Enum.reduce({[], []}, fn line, {left, right} ->
      [l, r] = String.split(line, ~r/\s+/)

      new_left = [String.to_integer(l) | left]
      new_right = [String.to_integer(r) | right]
      {new_left, new_right}
    end)
  end
end
