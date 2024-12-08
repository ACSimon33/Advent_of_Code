const std = @import("std");
const zig_template = @import("zig_template");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        0,
        zig_template.solution_1(example_input),
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        1,
        zig_template.solution_2(example_input),
    );
}
