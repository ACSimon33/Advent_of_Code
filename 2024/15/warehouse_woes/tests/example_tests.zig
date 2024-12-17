const std = @import("std");
const warehouse_woes = @import("warehouse_woes");
const testing = std.testing;

// Test of part 1
test "task_1_input_1" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        2028,
        warehouse_woes.simulate_robot(example_input, std.testing.allocator),
    );
}

test "task_1_input_2" {
    const example_input = @embedFile("example_input_2");
    try testing.expectEqual(
        10092,
        warehouse_woes.simulate_robot(example_input, std.testing.allocator),
    );
}

// Test of part 2
test "task_2_input_2" {
    const example_input = @embedFile("example_input_2");
    try testing.expectEqual(
        9021,
        warehouse_woes.simulate_robot_in_expanded_warehouse(example_input, std.testing.allocator),
    );
}
