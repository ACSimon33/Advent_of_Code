defmodule ElixirTemplateTest do
  use ExUnit.Case
  doctest ElixirTemplate

  test "solution_1 returns length" do
    input = File.read!("input/example_input.txt")
    assert ElixirTemplate.solution_1(input) == 16
  end

  test "solution_2 returns length" do
    input = File.read!("input/example_input.txt")
    assert ElixirTemplate.solution_2(input) == 16
  end
end
