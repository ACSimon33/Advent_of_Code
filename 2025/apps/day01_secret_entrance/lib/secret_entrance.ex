defmodule SecretEntrance do
  @doc """
  Count the number of times the dial points at zero at the end of a move.
  """
  def dial_at_zero(input) do
    input
    |> String.replace("L", "-")
    |> String.replace("R", "")
    |> String.split(["\r\n", "\n", "\r"], trim: true)
    |> Enum.reduce([50, 0], fn num, acc ->
      [position, count] = acc
      new_position = position + String.to_integer(num)

      [new_position, count + bool_to_int(rem(new_position, 100) == 0)]
    end)
    |> Enum.at(1)
  end

  @doc """
  Count the number of times the dial points at zero during the entire sequence of moves.
  """
  def zero_crossings(input) do
    input
    |> String.replace("L", "-")
    |> String.replace("R", "")
    |> String.split(["\n", "\r\n"], trim: true)
    |> Enum.reduce([50, 0], fn num, acc ->
      [position, count] = acc
      new_position = position + String.to_integer(num)

      [
        new_position,
        count + bool_to_int(rem(new_position, 100) == 0) +
          count_zero_crossings(position, new_position)
      ]
    end)
    |> Enum.at(1)
  end

  # Convert a boolean value to an integer (1 for true, 0 for false).
  defp bool_to_int(bool) do
    if bool, do: 1, else: 0
  end

  # Count the number of times the dial crosses zero between two positions. Does
  # not count when starting or ending exactly at zero.
  defp count_zero_crossings(a, b) do
    [low, high] = enclosing_integers(a / 100.0, b / 100.0)
    high - low - 1
  end

  # Given two floats, return the enclosing integers as a list.
  defp enclosing_integers(a, b) do
    if a < b do
      [floor(a), ceil(b)]
    else
      [floor(b), ceil(a)]
    end
  end
end
