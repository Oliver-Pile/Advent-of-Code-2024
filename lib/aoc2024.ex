defmodule Aoc2024 do
  def get_file_lines(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
  end
end
