defmodule ElixirTemplateTest do
  use ExUnit.Case
  doctest ElixirTemplate

  test "task_1" do
    input = File.read!("input/example_input.txt")
    assert ElixirTemplate.task_1(input) == 16
  end

  test "task_2" do
    input = File.read!("input/example_input.txt")
    assert ElixirTemplate.task_2(input) == 16
  end
end
