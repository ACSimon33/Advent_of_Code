const std = @import("std");
const ram_run = @import("ram_run");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        22,
        ram_run.steps_to_the_exit(example_input, 12, std.testing.allocator),
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input");
    const result = try ram_run.position_of_blocking_byte(example_input, std.testing.allocator);
    defer std.testing.allocator.free(result);

    try testing.expectEqualStrings(
        "6,1",
        result,
    );
}
