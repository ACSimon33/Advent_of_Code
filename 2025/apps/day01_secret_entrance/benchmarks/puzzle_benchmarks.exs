defmodule SecretEntrance.Benchmark do
  def jobs do
    input = File.read!(Path.join(__DIR__, "../input/puzzle_input.txt"))

    %{
      "day01.secret_entrance.dial_at_zero" => fn -> SecretEntrance.dial_at_zero(input) end,
      "day01.secret_entrance.zero_crossings" => fn -> SecretEntrance.zero_crossings(input) end
    }
  end
end

if System.get_env("AOC_COMBINED_BENCHMARK") do
  SecretEntrance.Benchmark.jobs()
else
  Benchee.run(
    SecretEntrance.Benchmark.jobs(),
    print: [fast_warning: false],
    formatters: [{Benchee.Formatters.Console, extended_statistics: true}],
    warmup: 1,
    time: 2,
    memory_time: 2,
    reduction_time: 2
  )
end
