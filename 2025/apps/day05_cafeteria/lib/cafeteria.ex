defmodule Cafeteria do
  @doc """
  Check how many ingredient IDs are considered fresh based on the provided ranges.
  """
  def fresh_ingredients(input) do
    [range_section, id_section] = input |> String.split(["\r\n\r\n", "\n\n"], trim: true)

    id_ranges =
      range_section
      |> String.split(["\r\n", "\n"], trim: true)
      |> Enum.map(fn range ->
        [min, max] = range |> String.split("-", trim: true) |> Enum.map(&String.to_integer/1)
        {min, max}
      end)

    ids =
      id_section
      |> String.split(["\r\n", "\n"], trim: true)
      |> Enum.map(&String.to_integer/1)

    Enum.filter(ids, fn id ->
      Enum.any?(id_ranges, fn {min, max} -> id >= min and id <= max end)
    end)
    |> Enum.count()
  end

  @doc """
  Calculate the total number of unique fresh ingredient IDs based on the provided ranges.
  """
  def all_fresh_ingredient_ids(input) do
    [range_section, _] = input |> String.split(["\r\n\r\n", "\n\n"], trim: true)

    id_ranges =
      range_section
      |> String.split(["\r\n", "\n"], trim: true)
      |> Enum.map(fn range ->
        [min, max] = range |> String.split("-", trim: true) |> Enum.map(&String.to_integer/1)
        {min, max}
      end)

    merge_ranges(id_ranges)
    |> Enum.reduce(0, fn {min, max}, acc -> acc + (max - min + 1) end)
  end

  # Merge all overlapping ranges
  defp merge_ranges(ranges) do
    ranges
    |> Enum.sort_by(fn {min, _max} -> min end)
    |> Enum.reduce([], fn
      {min, max}, [] ->
        [{min, max}]

      {min, max}, [{last_min, last_max} | rest] ->
        if min <= last_max do
          new_max = max(last_max, max)
          [{last_min, new_max} | rest]
        else
          [{min, max}, {last_min, last_max} | rest]
        end
    end)
  end
end
