defmodule Cafeteria.Benchmark do
  def jobs do
    input = File.read!(Path.join(__DIR__, "../input/puzzle_input.txt"))

    %{
      "day05.cafeteria.fresh_ingredients" => fn -> Cafeteria.fresh_ingredients(input) end,
      "day05.cafeteria.all_fresh_ingredient_ids" => fn -> Cafeteria.all_fresh_ingredient_ids(input) end
    }
  end
end

if System.get_env("AOC_COMBINED_BENCHMARK") do
  Cafeteria.Benchmark.jobs()
else
  Benchee.run(
    Cafeteria.Benchmark.jobs(),
    print: [fast_warning: false],
    formatters: [{Benchee.Formatters.Console, extended_statistics: true}],
    warmup: 1,
    time: 2,
    memory_time: 2,
    reduction_time: 2
  )
end
