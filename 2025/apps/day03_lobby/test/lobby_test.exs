defmodule LobbyTest do
  use ExUnit.Case
  doctest Lobby

  test "largest_joltage_sum_2" do
    input = File.read!("input/example_input.txt")
    assert Lobby.largest_joltage_sum(input, 2) == 357
  end

  test "largest_joltage_sum_12" do
    input = File.read!("input/example_input.txt")
    assert Lobby.largest_joltage_sum(input, 12) == 3_121_910_778_619
  end
end
