const std = @import("std");
const hoof_it = @import("hoof_it");
const testing = std.testing;

// Test of part 1
test "task_1_input_1" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        36,
        hoof_it.sum_of_trailhead_scores(example_input),
    );
}

test "task_1_input_2" {
    const example_input = @embedFile("example_input_2");
    try testing.expectEqual(
        2,
        hoof_it.sum_of_trailhead_scores(example_input),
    );
}

test "task_1_input_3" {
    const example_input = @embedFile("example_input_3");
    try testing.expectEqual(
        4,
        hoof_it.sum_of_trailhead_scores(example_input),
    );
}

test "task_1_input_4" {
    const example_input = @embedFile("example_input_4");
    try testing.expectEqual(
        3,
        hoof_it.sum_of_trailhead_scores(example_input),
    );
}

// Test of part 2
test "task_2_input_1" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        81,
        hoof_it.sum_of_trailhead_ratings(example_input),
    );
}

test "task_2_input_5" {
    const example_input = @embedFile("example_input_5");
    try testing.expectEqual(
        3,
        hoof_it.sum_of_trailhead_ratings(example_input),
    );
}

test "task_2_input_6" {
    const example_input = @embedFile("example_input_6");
    try testing.expectEqual(
        13,
        hoof_it.sum_of_trailhead_ratings(example_input),
    );
}

test "task_2_input_7" {
    const example_input = @embedFile("example_input_7");
    try testing.expectEqual(
        227,
        hoof_it.sum_of_trailhead_ratings(example_input),
    );
}
