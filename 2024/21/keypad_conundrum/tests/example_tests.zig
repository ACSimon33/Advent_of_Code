const std = @import("std");
const keypad_conundrum = @import("keypad_conundrum");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        126384,
        keypad_conundrum.number_of_keys(example_input, 3, std.testing.allocator),
    );
}
