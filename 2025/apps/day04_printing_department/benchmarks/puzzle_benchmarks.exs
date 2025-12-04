defmodule PrintingDepartment.Benchmark do
  def jobs do
    input = File.read!(Path.join(__DIR__, "../input/puzzle_input.txt"))

    %{
      "day04.printing_department.removable_rolls" => fn -> PrintingDepartment.removable_rolls(input) end,
      "day04.printing_department.removed_rolls" => fn -> PrintingDepartment.removed_rolls(input) end
    }
  end
end

if System.get_env("AOC_COMBINED_BENCHMARK") do
  PrintingDepartment.Benchmark.jobs()
else
  Benchee.run(
    PrintingDepartment.Benchmark.jobs(),
    print: [fast_warning: false],
    formatters: [{Benchee.Formatters.Console, extended_statistics: true}],
    warmup: 1,
    time: 2,
    memory_time: 2,
    reduction_time: 2
  )
end
