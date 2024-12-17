const std = @import("std");
const bridge_repair = @import("bridge_repair");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        3749,
        bridge_repair.total_calibration_result(example_input, std.testing.allocator),
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        11387,
        bridge_repair.total_calibration_result_with_concatenation(example_input, std.testing.allocator),
    );
}
