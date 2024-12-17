const std = @import("std");
const restroom_redoubt = @import("restroom_redoubt");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        12,
        restroom_redoubt.security_factor(
            example_input,
            100,
            11,
            7,
            std.testing.allocator,
        ),
    );
}
