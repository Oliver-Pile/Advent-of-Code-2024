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

  # Issue was the the state of do/dont should have been persisted within line changes. So combines all lines together and then ran it.
  def part2() do
    input_str =
      Aoc2024.get_file_lines("./input/day3.txt")
      |> Enum.join("\n")

    Regex.scan(~r/(?:mul\((\d{1,3}),(\d{1,3})\)|(do\(\))|(don't\(\)))/, input_str,
      capture: :all_but_first
    )
    |> Enum.reduce({:do, 0}, fn val, {state, count} ->
      {state_only, new_state} = check_state(val, state)

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
