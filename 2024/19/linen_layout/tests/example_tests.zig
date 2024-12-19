const std = @import("std");
const linen_layout = @import("linen_layout");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        6,
        linen_layout.possible_designs(example_input, std.testing.allocator),
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        16,
        linen_layout.towel_combinations(example_input, std.testing.allocator),
    );
}
