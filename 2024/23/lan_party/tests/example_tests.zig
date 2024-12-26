const std = @import("std");
const lan_party = @import("lan_party");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        7,
        lan_party.number_of_triples(example_input, std.testing.allocator),
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input");
    const result = try lan_party.largest_clique_password(example_input, std.testing.allocator);
    defer std.testing.allocator.free(result);
    try testing.expectEqualStrings("co,de,ka,ta", result);
}
