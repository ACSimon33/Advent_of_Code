defmodule Lobby.Benchmark do
  def jobs do
    input = File.read!(Path.join(__DIR__, "../input/puzzle_input.txt"))

    %{
      "day03.lobby.largest_joltage_sum_2" => fn -> Lobby.largest_joltage_sum(input, 2) end,
      "day03.lobby.largest_joltage_sum_12" => fn -> Lobby.largest_joltage_sum(input, 12) end
    }
  end
end

if System.get_env("AOC_COMBINED_BENCHMARK") do
  Lobby.Benchmark.jobs()
else
  Benchee.run(
    Lobby.Benchmark.jobs(),
    print: [fast_warning: false],
    formatters: [{Benchee.Formatters.Console, extended_statistics: true}],
    warmup: 1,
    time: 2,
    memory_time: 2,
    reduction_time: 2
  )
end
