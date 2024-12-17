const std = @import("std");
const claw_contraption = @import("claw_contraption");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        480,
        claw_contraption.cost_to_win_all_prizes(
            example_input,
            0,
            std.testing.allocator,
        ),
    );
}
