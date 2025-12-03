defmodule Lobby.CLI do
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
    IO.puts("Largest joltage (2 batteries): #{Lobby.largest_joltage_sum(input, 2)}")
    IO.puts("Largest joltage (12 batteries): #{Lobby.largest_joltage_sum(input, 12)}")
  end
end
