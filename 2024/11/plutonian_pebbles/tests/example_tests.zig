const std = @import("std");
const plutonian_pebbles = @import("plutonian_pebbles");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        55312,
        plutonian_pebbles.amount_of_stones(
            example_input,
            25,
            std.testing.allocator,
        ),
    );
}
