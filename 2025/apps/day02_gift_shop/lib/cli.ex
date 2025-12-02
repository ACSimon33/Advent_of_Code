defmodule GiftShop.CLI do
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
    IO.puts("Invalid ID sum (2-fold repetition): #{GiftShop.invalid_id_sum(input)}")

    IO.puts(
      "Invalid ID sum (n-fold repetition, n >= 2): #{GiftShop.extended_invalid_id_sum(input)}"
    )
  end
end
