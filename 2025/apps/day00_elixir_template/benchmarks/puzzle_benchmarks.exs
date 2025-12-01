day_dir = Path.expand("..", __DIR__)
input = File.read!(Path.join(day_dir, "input/puzzle_input.txt"))

Benchee.run(
  %{
    "elixir_template.task_1" => fn -> ElixirTemplate.task_1(input) end,
    "elixir_template.task_2" => fn -> ElixirTemplate.task_2(input) end
  },
  print: [fast_warning: false],
  formatters: [
    {Benchee.Formatters.Console, extended_statistics: true},
    {Benchee.Formatters.HTML, file: Path.join(day_dir, "../../_build/benchmarks/elixir_template.html")}
  ],
  warmup: 1,
  time: 2,
  memory_time: 2,
  reduction_time: 2
)
