defmodule SecretEntranceTest do
  use ExUnit.Case
  doctest SecretEntrance

  test "dial_at_zero" do
    input = File.read!("input/example_input.txt")
    assert SecretEntrance.dial_at_zero(input) == 3
  end

  test "zero_crossings" do
    input = File.read!("input/example_input.txt")
    assert SecretEntrance.zero_crossings(input) == 6
  end
end
