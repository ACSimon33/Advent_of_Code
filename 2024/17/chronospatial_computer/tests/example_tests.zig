const std = @import("std");
const chronospatial_computer = @import("chronospatial_computer");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input_1");
    const output = try chronospatial_computer.simulate_program(
        example_input,
        std.testing.allocator,
    );
    defer std.testing.allocator.free(output);

    try testing.expectEqualStrings("4,6,3,5,6,3,5,2,1,0", output);
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input_2");
    try testing.expectEqual(
        117440,
        chronospatial_computer.debug_program(
            example_input,
            std.testing.allocator,
        ),
    );
}
