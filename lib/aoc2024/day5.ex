defmodule Aoc2024.Day5 do
  @path "./input/day5.txt"
  def part1() do
    file_str = File.read!(@path)

    lines = get_split_lines()

    rules = extract_rule(file_str)

    good_updates = find_good_updates(rules, lines)

    mid_points = find_mid_values(good_updates)

    Enum.sum(mid_points)
  end

  defp get_split_lines() do
    Aoc2024.get_file_lines(@path)
    |> Enum.filter(&String.contains?(&1, ","))
    |> Enum.map(&String.split(&1, ","))
  end

  defp find_mid_values(good_updates) do
    Enum.map(good_updates, fn update ->
      middle_index = update |> length() |> div(2)
      Enum.at(update, middle_index) |> String.to_integer()
    end)
  end

  defp find_good_updates(rules, lines) do
    Enum.filter(lines, fn line ->
      check_update(rules, Enum.reverse(line))
    end)
  end

  defp check_update(_rules, current) when length(current) == 1 do
    true
  end

  defp check_update(rules, [current | rest]) do
    after_numbers = Map.get(rules, current, [])

    cond do
      after_numbers == [] -> check_update(rules, rest)
      Enum.any?(after_numbers, &(&1 in rest)) -> false
      true -> check_update(rules, rest)
    end
  end

  defp extract_rule(str) do
    Regex.scan(~r/(\d+)\|(\d+)/m, str, capture: :all_but_first)
    |> Enum.group_by(fn [bef, _aft] -> bef end, fn [_bef, aft] -> aft end)
  end

  def part2() do
    file_str = File.read!(@path)

    lines = get_split_lines()

    rules = extract_rule(file_str)

    bad_updates = find_bad_updates(rules, lines)

    sorted_updates = sort_updates(bad_updates, rules)

    mid_points = find_mid_values(sorted_updates)

    Enum.sum(mid_points)
  end

  defp find_bad_updates(rules, lines) do
    Enum.reject(lines, fn line ->
      check_update(rules, Enum.reverse(line))
    end)
  end

  defp sort_updates(bad_updates, rules) do
    Enum.map(bad_updates, fn update ->
      check_bad_update(rules, Enum.reverse(update), []) |> List.flatten()
    end)
  end

  defp check_bad_update(_rules, current, good_elements) when length(current) == 1 do
    [current | good_elements]
  end

  defp check_bad_update(rules, [current | rest], good_elements) do
    after_numbers = Map.get(rules, current, [])

    cond do
      after_numbers == [] ->
        check_bad_update(rules, rest, [current | good_elements])

      Enum.any?(after_numbers, &(&1 in rest)) ->
        new_update = List.flatten([rest, current])
        check_bad_update(rules, new_update, good_elements)

      true ->
        check_bad_update(rules, rest, [current | good_elements])
    end
  end
end
