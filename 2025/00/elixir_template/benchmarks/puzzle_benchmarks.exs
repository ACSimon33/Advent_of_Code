input = File.read!("input/puzzle_input.txt")

Benchee.run(
  %{
    "solution_1" => fn -> ElixirTemplate.solution_1(input) end,
    "solution_2" => fn -> ElixirTemplate.solution_2(input) end
  },
  print: [fast_warning: false],
  formatters: [
    {Benchee.Formatters.Console, extended_statistics: true},
    {Benchee.Formatters.HTML, file: "_build/benchmarks/elixir_template.html"}
  ],
  warmup: 1,
  time: 2,
  memory_time: 2,
  reduction_time: 2
)
