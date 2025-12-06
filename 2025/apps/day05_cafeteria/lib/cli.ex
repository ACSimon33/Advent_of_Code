defmodule Cafeteria.CLI do
  def main(args) do
    args |> parse_args |> read_file |> run
  end

  defp parse_args(args) do
    {options, _, _} =
      OptionParser.parse(args, switches: [filename: :string], aliases: [f: :filename])

    options[:filename]
  end

  defp read_file(nil) do
    IO.puts("Usage: --filename <filename> or -f <filename>")
    System.halt(1)
  end

  defp read_file(filename) do
    File.read!(filename)
  end

  defp run(input) do
    IO.puts("Number of fresh ingredients: #{Cafeteria.fresh_ingredients(input)}")
    IO.puts("Number of all fresh ingredient IDs: #{Cafeteria.all_fresh_ingredient_ids(input)}")
  end
end
