defmodule Aoc2024.Day2 do
  def part1() do
    Aoc2024.get_file_lines("./input/day2.txt")
    |> Enum.map(fn line ->
      String.split(line, ~r/\s+/) |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(&check_line_ok/1)
    |> Enum.count(fn {status, _} ->
      status
    end)
  end

  defp check_line_ok(line) do
    all_incr_decr? = check_all_increasing_decreasing(line)
    all_good_diff? = check_differences(line)

    status = all_incr_decr? and all_good_diff?
    {status, line}
  end

  defp check_all_increasing_decreasing(line) do
    sorted = Enum.sort(line)

    line == sorted or line == Enum.reverse(sorted)
  end

  defp check_differences(line) do
    Enum.chunk_every(line, 2, 1, :discard)
    |> Enum.map(fn [x, y] ->
      abs(x - y)
    end)
    |> Enum.all?(&(&1 >= 1 and &1 <= 3))
  end

  # Initial thinking was to go through and first alter the list of levels to remove any with issues.
  # Had to go in the end of checking them all first, then filtering out the failed. With this failed list...
  # go through and try deleting each level one by one until it either was ok or ran out of elements.
  # Thanks to Ben's code for the suggestion :)
  def part2() do
    lines =
      Aoc2024.get_file_lines("./input/day2.txt")
      |> Enum.map(fn line ->
        String.split(line, ~r/\s+/) |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.map(&check_line_ok/1)

    good_count =
      Enum.filter(lines, fn {status, _} -> status end)
      |> length()

    bad_lines =
      Enum.filter(lines, fn {status, _} -> status == false end)
      |> Enum.map(fn {_, line} -> line end)

    bad_now_ok_count =
      Enum.filter(bad_lines, fn line ->
        length = length(line)

        ok_or_line =
          Enum.reduce_while(0..(length - 1), line, fn index, acc ->
            {line_ok, _} = check_line_ok(List.delete_at(acc, index))

            if line_ok do
              {:halt, :ok}
            else
              {:cont, line}
            end
          end)

        ok_or_line == :ok
      end)
      |> length()

    good_count + bad_now_ok_count
  end
end
