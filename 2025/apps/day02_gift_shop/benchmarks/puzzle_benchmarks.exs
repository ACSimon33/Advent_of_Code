defmodule GiftShop.Benchmark do
  def jobs do
    input = File.read!(Path.join(__DIR__, "../input/puzzle_input.txt"))

    %{
      "day02.gift_shop.invalid_id_sum" => fn -> GiftShop.invalid_id_sum(input) end,
      "day02.gift_shop.extended_invalid_id_sum" => fn -> GiftShop.extended_invalid_id_sum(input) end
    }
  end
end

if System.get_env("AOC_COMBINED_BENCHMARK") do
  GiftShop.Benchmark.jobs()
else
  Benchee.run(
    GiftShop.Benchmark.jobs(),
    print: [fast_warning: false],
    formatters: [{Benchee.Formatters.Console, extended_statistics: true}],
    warmup: 1,
    time: 2,
    memory_time: 2,
    reduction_time: 2
  )
end
