const std = @import("std");
const red_nosed_reports = @import("red_nosed_reports");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        2,
        red_nosed_reports.number_of_safe_reports(example_input),
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        4,
        red_nosed_reports.number_of_partially_safe_reports(example_input),
    );
}
