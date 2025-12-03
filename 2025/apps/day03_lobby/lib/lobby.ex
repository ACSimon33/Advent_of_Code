defmodule Lobby do
  @doc """
  Calculate the largest possible joltage sum from a list of battery banks,
  where each battery bank is represented as a string of digits. The number of
  batteries to use from each bank is specified by the `batteries` parameter.
  """
  def largest_joltage_sum(input, batteries) do
    input
    |> String.split(["\n", "\r\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&Integer.digits/1)
    |> Enum.map(fn bank ->
      largest_joltage(bank, batteries)
    end)
    |> Enum.sum()
  end

  # Get the largest joltage that can be formed using the specified number of batteries.
  defp largest_joltage(battery_bank, batteries) do
    max_battery = battery_bank |> Enum.reverse() |> Enum.drop(batteries - 1) |> Enum.max()

    case batteries do
      1 ->
        max_battery

      _ ->
        max_battery * 10 ** (batteries - 1) +
          largest_joltage(
            battery_bank
            |> Enum.drop_while(fn joltage -> joltage != max_battery end)
            |> Enum.drop(1),
            batteries - 1
          )
    end
  end
end
