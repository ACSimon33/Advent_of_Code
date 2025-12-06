defmodule CafeteriaTest do
  use ExUnit.Case
  doctest Cafeteria

  test "fresh_ingredients" do
    input = File.read!("input/example_input.txt")
    assert Cafeteria.fresh_ingredients(input) == 3
  end

  test "all_fresh_ingredient_ids" do
    input = File.read!("input/example_input.txt")
    assert Cafeteria.all_fresh_ingredient_ids(input) == 14
  end
end
