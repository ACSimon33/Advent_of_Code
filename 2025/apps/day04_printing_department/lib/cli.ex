defmodule PrintingDepartment.CLI do
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
    IO.puts(
      "Number of removable rolls at the beginning: #{PrintingDepartment.removable_rolls(input)}"
    )

    IO.puts("Number of removed rolls in total: #{PrintingDepartment.removed_rolls(input)}")
  end
end
