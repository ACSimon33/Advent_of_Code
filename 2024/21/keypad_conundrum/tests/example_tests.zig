const std = @import("std");
const keypad_conundrum = @import("keypad_conundrum");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        126384,
        keypad_conundrum.code_complexities(example_input, 3, std.testing.allocator),
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        154115708116294,
        keypad_conundrum.code_complexities(example_input, 26, std.testing.allocator),
    );
}
