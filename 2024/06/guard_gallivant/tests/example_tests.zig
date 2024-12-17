const std = @import("std");
const guard_gallivant = @import("guard_gallivant");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        41,
        guard_gallivant.visited_positions(example_input, std.testing.allocator),
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        6,
        guard_gallivant.closed_loops(example_input, std.testing.allocator),
    );
}
