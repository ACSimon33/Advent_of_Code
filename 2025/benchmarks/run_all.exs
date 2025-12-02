System.put_env("AOC_COMBINED_BENCHMARK", "true")

# Ensure all apps are compiled and loaded
Mix.Task.run("compile")

jobs =
  Path.wildcard("apps/*/benchmarks/puzzle_benchmarks.exs")
  |> Enum.reduce(%{}, fn file, acc ->
    IO.puts("Loading benchmarks from #{file}...")
    {new_jobs, _} = Code.eval_file(file)
    Map.merge(acc, new_jobs)
  end)

if map_size(jobs) > 0 do
  Benchee.run(
    jobs,
    print: [fast_warning: false],
    formatters: [
      {Benchee.Formatters.Console, extended_statistics: true},
      {Benchee.Formatters.HTML, file: "_build/benchmarks/aoc2025.html", auto_open: false}
    ],
    warmup: 1,
    time: 2,
    memory_time: 2,
    reduction_time: 2
  )
else
  IO.puts("No benchmarks found.")
end
