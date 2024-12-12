const std = @import("std");
const garden_groups = @import("garden_groups");
const testing = std.testing;

// Test of part 1
test "task_1_input_1" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        140,
        garden_groups.fence_cost(example_input),
    );
}

test "task_1_input_2" {
    const example_input = @embedFile("example_input_2");
    try testing.expectEqual(
        772,
        garden_groups.fence_cost(example_input),
    );
}

test "task_1_input_3" {
    const example_input = @embedFile("example_input_3");
    try testing.expectEqual(
        1930,
        garden_groups.fence_cost(example_input),
    );
}

// Test of part 2
test "task_2_input_1" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        80,
        garden_groups.fence_cost_with_bulk_discount(example_input),
    );
}

test "task_2_input_2" {
    const example_input = @embedFile("example_input_2");
    try testing.expectEqual(
        436,
        garden_groups.fence_cost_with_bulk_discount(example_input),
    );
}

test "task_2_input_3" {
    const example_input = @embedFile("example_input_3");
    try testing.expectEqual(
        1206,
        garden_groups.fence_cost_with_bulk_discount(example_input),
    );
}

test "task_2_input_4" {
    const example_input = @embedFile("example_input_4");
    try testing.expectEqual(
        236,
        garden_groups.fence_cost_with_bulk_discount(example_input),
    );
}

test "task_2_input_5" {
    const example_input = @embedFile("example_input_5");
    try testing.expectEqual(
        368,
        garden_groups.fence_cost_with_bulk_discount(example_input),
    );
}
