defmodule GiftShop do
  @doc """
  Sum up all invalid gift IDs that are made of a 2-fold repetition of a number.
  """
  def invalid_id_sum(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.map(fn [a, b] ->
      invalid_ids_in_range(String.to_integer(a), String.to_integer(b), 2)
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  @doc """
  Sum up all invalid gift IDs that are made of a n-fold repetition of a number, for n >= 2.
  """
  def extended_invalid_id_sum(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.map(fn [a, b] ->
      Enum.map(2..length(Integer.digits(String.to_integer(b))), fn repeats ->
        invalid_ids_in_range(String.to_integer(a), String.to_integer(b), repeats)
      end)
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sum()
  end

  # Get all invalid IDs in the range [a, b] that are made of `repeats`-fold repetition of a number.
  defp invalid_ids_in_range(a, b, repeats) do
    Enum.map(
      first_number_part(a, repeats, :floor)..first_number_part(b, repeats, :ceil),
      fn num ->
        num |> Integer.digits() |> List.duplicate(repeats) |> List.flatten() |> Integer.undigits()
      end
    )
    |> Enum.filter(fn num -> num >= a and num <= b end)
  end

  # Get the first part of the number when split into `repeats` parts.
  defp first_number_part(num, repeats, rounding) do
    digits = Integer.digits(num)

    split_point =
      case rounding do
        :floor -> floor(length(digits) / repeats)
        :ceil -> ceil(length(digits) / repeats)
      end

    digits
    |> Enum.split(split_point)
    |> elem(0)
    |> Integer.undigits()
  end
end
