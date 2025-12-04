defmodule PrintingDepartment do
  @doc """
  Calculates the number of removable rolls at the beginning.
  """
  def removable_rolls(input) do
    input
    |> parse_input()
    |> neighbour_sums(grid_width(input))
    |> count_removable_rolls()
  end

  @doc """
  Calculates the total number of removed rolls, until no more rolls can be removed.
  """
  def removed_rolls(input) do
    input
    |> parse_input()
    |> remove_rolls(grid_width(input))
  end

  # Number of rolls in a row, including the added 0s at the end of each line
  defp grid_width(input) do
    (input |> String.split(["\r\n", "\n"], trim: true) |> Enum.at(0) |> String.length()) + 1
  end

  # Transforms the input into a list of integers representing the grid
  defp parse_input(input) do
    input
    |> String.split(["\r\n", "\n"], trim: true)
    |> Enum.join("0")
    |> String.replace(".", "0")
    |> String.replace("@", "1")
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  # Count the number of removable rolls based on the neighbour sums
  defp count_removable_rolls(neighbours) do
    neighbours
    |> Enum.filter(&(&1 >= 0 and &1 < 4))
    |> Enum.count()
  end

  # Recursively removes rolls until no more can be removed
  defp remove_rolls(grid, width) do
    neighbours = neighbour_sums(grid, width)
    rolls_to_remove = count_removable_rolls(neighbours)

    rolls_to_remove +
      case rolls_to_remove do
        0 ->
          0

        _ ->
          remove_rolls(
            grid
            |> Enum.zip(neighbours)
            |> Enum.map(fn {roll, neighbour_sum} ->
              if neighbour_sum < 4, do: 0, else: roll
            end),
            width
          )
      end
  end

  # Calculates the sum of neighbour rolls for each roll in the grid
  defp neighbour_sums(grid, width) do
    shift_list(grid, -1)
    |> add_lists(shift_list(grid, 1))
    |> add_lists(shift_list(grid, -width))
    |> add_lists(shift_list(grid, width))
    |> add_lists(shift_list(grid, -width - 1))
    |> add_lists(shift_list(grid, -width + 1))
    |> add_lists(shift_list(grid, width - 1))
    |> add_lists(shift_list(grid, width + 1))
    |> Enum.zip(grid)
    |> Enum.map(fn {neighbours, roll} -> if roll == 1, do: neighbours, else: -1 end)
  end

  # Element-wise addition of two lists
  defp add_lists(list1, list2) do
    Enum.zip(list1, list2)
    |> Enum.map(fn {a, b} -> a + b end)
  end

  # Shifts a list by n positions, filling with 0s. Negative n shifts left,
  # positive n shifts right.
  defp shift_list(grid, n) do
    len = length(grid)
    start_idx = max(0, -n)
    end_idx = len - max(0, n)

    grid.duplicate(0, max(0, n)) ++
      Enum.slice(grid, start_idx..end_idx) ++
      grid.duplicate(0, max(0, -n))
  end
end
