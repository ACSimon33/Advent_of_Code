defmodule PrintingDepartmentTest do
  use ExUnit.Case
  doctest PrintingDepartment

  test "removable_rolls" do
    input = File.read!("input/example_input.txt")
    assert PrintingDepartment.removable_rolls(input) == 13
  end

  test "removed_rolls" do
    input = File.read!("input/example_input.txt")
    assert PrintingDepartment.removed_rolls(input) == 43
  end
end
