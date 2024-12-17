const std = @import("std");
const mull_it_over = @import("mull_it_over");
const testing = std.testing;

// Test of part 1
test "task_1_input_1" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        161,
        mull_it_over.sum_of_multiplication_instructions(example_input, std.testing.allocator),
    );
}

// Test of part 2
test "task_2_input_1" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        161,
        mull_it_over.conditional_sum_of_multiplication_instructions(example_input, std.testing.allocator),
    );
}

test "task_2_input_2" {
    const example_input = @embedFile("example_input_2");
    try testing.expectEqual(
        48,
        mull_it_over.conditional_sum_of_multiplication_instructions(example_input, std.testing.allocator),
    );
}
