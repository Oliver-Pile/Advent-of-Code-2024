defmodule Aoc2024.Day3 do
  def part1() do
    Aoc2024.get_file_lines("./input/day3.txt")
    |> Enum.map(fn line ->
      Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, line, capture: :all_but_first)
      |> Enum.map(fn [x, y] ->
        String.to_integer(x) * String.to_integer(y)
      end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  def part2() do
    Aoc2024.get_file_lines("./input/test.txt")
    |> Enum.map(fn line ->
      Regex.scan(~r/(?:mul\((\d{1,3}),(\d{1,3})\)|(do\(\))|(don't\(\)))/, line,
        capture: :all_but_first
      )
      |> Enum.reduce({:do, 0}, fn val, {state, count} ->
        IO.inspect(count, label: :acc)
        IO.inspect(val)
        {state_only, new_state} = check_state(val, state) |> IO.inspect()

        cond do
          state_only ->
            {new_state, count}

          new_state == :dont ->
            {new_state, count}

          true ->
            [x, y] = val
            mult = String.to_integer(x) * String.to_integer(y)
            {new_state, count + mult}
        end
      end)
      |> elem(1)
    end)
    |> List.flatten()
    |> Enum.sum()
    |> IO.inspect()
  end

  defp check_state(vals, state) do
    cond do
      "do()" in vals ->
        {true, :do}

      "don't()" in vals ->
        {true, :dont}

      true ->
        {false, state}
    end
  end
end
