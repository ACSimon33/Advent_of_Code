const std = @import("std");
const crossed_wires = @import("crossed_wires");
const testing = std.testing;

// Test of part 1
test "task_1_input_1" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        4,
        crossed_wires.simulate_gates(example_input, std.testing.allocator),
    );
}

test "task_1_input_2" {
    const example_input = @embedFile("example_input_2");
    try testing.expectEqual(
        2024,
        crossed_wires.simulate_gates(example_input, std.testing.allocator),
    );
}
