const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const HashMap = std.AutoArrayHashMap;
const string = []const u8;

/// Task 1 - Find all unique triples of pairwise connected computers where at
///          least one of the computer's IDs start with 't'.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Number of triples of pairwise connected computers.
pub fn number_of_triples(contents: string, main_allocator: Allocator) !u32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const network = try parse_network(contents, allocator);
    const nodes = network.computers.count();
    const ids = network.computers.keys();

    var triples: u32 = 0;
    for (0..nodes) |idx1| {
        if (ids[idx1][0] == 't') {
            for (0..nodes) |idx2| {
                if (ids[idx2][0] == 't' and idx2 < idx1) {
                    continue;
                }
                for (idx2..nodes) |idx3| {
                    if (ids[idx3][0] == 't' and idx3 < idx1) {
                        continue;
                    }
                    triples += @intFromBool(true and
                        network.adjacency_matrix.items[idx1 * nodes + idx2] and
                        network.adjacency_matrix.items[idx1 * nodes + idx3] and
                        network.adjacency_matrix.items[idx2 * nodes + idx3]);
                }
            }
        }
    }

    return triples;
}

/// Task 2 - Find the password to the LAN party. The password is an ordered
///          concatenation of all computer IDs in the larest clique of the
///          network.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Password to the LAN party / largest clique.
pub fn largest_clique_password(contents: string, main_allocator: Allocator) !string {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const network = try parse_network(contents, allocator);
    var clique_buffer = ArrayList(usize).init(allocator);
    var largest_clique = ArrayList(usize).init(allocator);
    try find_largest_clique(
        network,
        &clique_buffer,
        0,
        &largest_clique,
    );

    std.mem.sort(usize, largest_clique.items, network, compare_computers);
    var password = try main_allocator.alloc(u8, 3 * largest_clique.items.len - 1);
    for (largest_clique.items, 0..) |computer, idx| {
        password[3 * idx] = network.computers.keys()[computer][0];
        password[3 * idx + 1] = network.computers.keys()[computer][1];
        if (3 * idx + 2 < 3 * largest_clique.items.len - 1) {
            password[3 * idx + 2] = ',';
        }
    }
    return password;
}

// -------------------------------------------------------------------------- \\

/// Network of computers as an undirected graph.
const Network = struct {
    computers: HashMap([2]u8, void),
    adjacency_matrix: ArrayList(bool),
};

/// Find the largest possible clique by adding new nodes to the clique in the
/// clique buffer. If no more nodes can be added to the clique, store it as the
/// largest clique if it was bigger than the largest clique before.
///
/// Arguments:
///   - `network`: The network.
///   - `clique_buffer`: Buffer containing nodes in the current clique.
///   - `start_idx`: The index from where we start trying to add new nodes to
///                  the clique.
///   - `largest_clique`: Buffer containing nodes in the largest clique found.
fn find_largest_clique(
    network: Network,
    clique_buffer: *ArrayList(usize),
    start_idx: usize,
    largest_clique: *ArrayList(usize),
) !void {
    for (start_idx..network.computers.count()) |idx| {
        var fits_in_clique = true;
        for (clique_buffer.items) |member| {
            if (!network.adjacency_matrix.items[member * network.computers.count() + idx]) {
                fits_in_clique = false;
                break;
            }
        }

        if (fits_in_clique) {
            try clique_buffer.append(idx);
            try find_largest_clique(
                network,
                clique_buffer,
                idx + 1,
                largest_clique,
            );
            _ = clique_buffer.pop();
        }
    }

    if (largest_clique.items.len < clique_buffer.items.len) {
        largest_clique.clearRetainingCapacity();
        try largest_clique.appendSlice(clique_buffer.items);
    }
}

/// Compare two computers by their IDs given their indices in the network.
///
/// Arguments:
///   - `network`: The network.
///   - `lhs`: The index of the first computer.
///   - `rhs`: The index of the second computer.
///
/// Returns:
///   - The order of the two computers (<).
fn compare_computers(network: Network, lhs: usize, rhs: usize) bool {
    return std.mem.order(
        u8,
        &network.computers.keys()[lhs],
        &network.computers.keys()[rhs],
    ).compare(std.math.CompareOperator.lt);
}

/// Parse the file contents into a network of computers
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - The network object (undirected graph of computers).
fn parse_network(contents: string, allocator: Allocator) !Network {
    var computers = HashMap([2]u8, void).init(allocator);
    var matrix = ArrayList(bool).init(allocator);

    // Parse computers
    var lines = std.mem.tokenize(u8, contents, "\r\n");
    while (lines.next()) |line| {
        var nodes = std.mem.split(u8, line, "-");
        try computers.put((nodes.next().?[0..2]).*, {});
        try computers.put((nodes.next().?[0..2]).*, {});
    }

    // Parse connections
    try matrix.appendNTimes(false, computers.count() * computers.count());
    lines.reset();
    while (lines.next()) |line| {
        var nodes = std.mem.split(u8, line, "-");
        const node1 = computers.getIndex((nodes.next().?[0..2]).*).?;
        const node2 = computers.getIndex((nodes.next().?[0..2]).*).?;
        matrix.items[node1 * computers.count() + node2] = true;
        matrix.items[node2 * computers.count() + node1] = true;
    }

    return Network{
        .computers = computers,
        .adjacency_matrix = matrix,
    };
}
