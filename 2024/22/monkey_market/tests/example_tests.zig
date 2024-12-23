const std = @import("std");
const monkey_market = @import("monkey_market");
const testing = std.testing;

// Test of part 1
test "task_1_input_1_step_1" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        15887950,
        monkey_market.sum_of_secret_numbers(example_input, 1, std.testing.allocator),
    );
}
test "task_1_input_1_step_2" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        16495136,
        monkey_market.sum_of_secret_numbers(example_input, 2, std.testing.allocator),
    );
}
test "task_1_input_1_step_3" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        527345,
        monkey_market.sum_of_secret_numbers(example_input, 3, std.testing.allocator),
    );
}
test "task_1_input_1_step_4" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        704524,
        monkey_market.sum_of_secret_numbers(example_input, 4, std.testing.allocator),
    );
}
test "task_1_input_1_step_5" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        1553684,
        monkey_market.sum_of_secret_numbers(example_input, 5, std.testing.allocator),
    );
}
test "task_1_input_1_step_6" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        12683156,
        monkey_market.sum_of_secret_numbers(example_input, 6, std.testing.allocator),
    );
}
test "task_1_input_1_step_7" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        11100544,
        monkey_market.sum_of_secret_numbers(example_input, 7, std.testing.allocator),
    );
}
test "task_1_input_1_step_8" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        12249484,
        monkey_market.sum_of_secret_numbers(example_input, 8, std.testing.allocator),
    );
}
test "task_1_input_1_step_9" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        7753432,
        monkey_market.sum_of_secret_numbers(example_input, 9, std.testing.allocator),
    );
}
test "task_1_input_1_step_10" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        5908254,
        monkey_market.sum_of_secret_numbers(example_input, 10, std.testing.allocator),
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input_3");
    try testing.expectEqual(
        23,
        monkey_market.max_bananas(example_input, 2000, std.testing.allocator),
    );
}
