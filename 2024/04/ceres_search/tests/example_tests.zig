const std = @import("std");
const ceres_search = @import("ceres_search");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        18,
        ceres_search.xmas_count(example_input),
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        9,
        ceres_search.x_mas_count(example_input),
    );
}
