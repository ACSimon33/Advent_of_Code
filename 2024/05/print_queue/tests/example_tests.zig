const std = @import("std");
const print_queue = @import("print_queue");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        143,
        print_queue.middle_page_sum_of_valid_updates(example_input),
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        123,
        print_queue.middle_page_sum_of_fixed_updates(example_input),
    );
}
