const std = @import("std");
const testing = std.testing;

const guard_gallivant = @import("guard_gallivant");

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        41,
        guard_gallivant.solution_1(example_input),
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        6,
        guard_gallivant.solution_2(example_input),
    );
}
