defmodule ElixirTemplate.Benchmark do
  def jobs do
    input = File.read!(Path.join(__DIR__, "../input/puzzle_input.txt"))

    %{
      "elixir_template.task_1" => fn -> ElixirTemplate.task_1(input) end,
      "elixir_template.task_2" => fn -> ElixirTemplate.task_2(input) end
    }
  end
end

if System.get_env("AOC_COMBINED_BENCHMARK") do
  ElixirTemplate.Benchmark.jobs()
else
  Benchee.run(
    ElixirTemplate.Benchmark.jobs(),
    print: [fast_warning: false],
    formatters: [{Benchee.Formatters.Console, extended_statistics: true}],
    warmup: 1,
    time: 2,
    memory_time: 2,
    reduction_time: 2
  )
end
