defmodule GiftShopTest do
  use ExUnit.Case
  doctest GiftShop

  test "invalid_id_sum" do
    input = File.read!("input/example_input.txt")
    assert GiftShop.invalid_id_sum(input) == 1_227_775_554
  end

  test "extended_invalid_id_sum" do
    input = File.read!("input/example_input.txt")
    assert GiftShop.extended_invalid_id_sum(input) == 4_174_379_265
  end
end
