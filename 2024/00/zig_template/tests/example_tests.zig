const std = @import("std");
const testing = std.testing;

const zig_template = @import("zig_template");

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        zig_template.solution_1(example_input),
        0,
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        zig_template.solution_2(example_input),
        1,
    );
}
