defmodule Aoc2024.Day4 do
  # Elixir doesnt like doing list[x][y]. Whilst I could work around it, I'd rather do it ideomatically. Will come back to this when I can figure that out.
  def part1() do
    lines =
      Aoc2024.get_file_lines("./input/test.txt")
      |> Enum.map(&String.split(&1, "", trim: true))
  end
end
