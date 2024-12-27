const std = @import("std");
const resonant_collinearity = @import("resonant_collinearity");
const testing = std.testing;

// Test of part 1
test "task_1_input_1" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        2,
        resonant_collinearity.number_of_outer_antinodes(example_input, std.testing.allocator),
    );
}

test "task_1_input_2" {
    const example_input = @embedFile("example_input_2");
    try testing.expectEqual(
        4,
        resonant_collinearity.number_of_outer_antinodes(example_input, std.testing.allocator),
    );
}

test "task_1_input_3" {
    const example_input = @embedFile("example_input_3");
    try testing.expectEqual(
        4,
        resonant_collinearity.number_of_outer_antinodes(example_input, std.testing.allocator),
    );
}

test "task_1_input_4" {
    const example_input = @embedFile("example_input_4");
    try testing.expectEqual(
        14,
        resonant_collinearity.number_of_outer_antinodes(example_input, std.testing.allocator),
    );
}

// Test of part 2
test "task_2_input_4" {
    const example_input = @embedFile("example_input_4");
    try testing.expectEqual(
        34,
        resonant_collinearity.number_of_all_antinodes(example_input, std.testing.allocator),
    );
}

test "task_2_input_5" {
    const example_input = @embedFile("example_input_5");
    try testing.expectEqual(
        9,
        resonant_collinearity.number_of_all_antinodes(example_input, std.testing.allocator),
    );
}
