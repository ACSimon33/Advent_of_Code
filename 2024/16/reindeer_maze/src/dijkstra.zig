const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const PriorityQueue = std.PriorityQueue;
const HashMap = std.AutoArrayHashMap;
const Order = std.math.Order;

/// A graph node that we want to run dijkstra on.
///
/// Arguments:
///   - `T`: Type of the distance.
///
/// Returns:
///   - The node type.
fn DijkstraNode(comptime T: type) type {
    return struct {
        idx: usize,
        distance: T,
        visited: bool,
        parents: ArrayList(*DijkstraNode(T)),
    };
}

/// Comparison function for dijkstra nodes used in the priority queue.
///
/// Arguments:
///   - `T`: The type of the dijkstra node distance.
///   - `Context`: Type of the context in the priority queue.
///
/// Returns:
///   - The comparison function.
fn dijkstraLessThan(comptime T: type, comptime Context: type) (fn (Context, *DijkstraNode(T), *DijkstraNode(T)) Order) {
    return struct {
        fn lessThan(context: Context, a: *DijkstraNode(T), b: *DijkstraNode(T)) Order {
            _ = context;
            return std.math.order(a.distance, b.distance);
        }
    }.lessThan;
}

/// Run dijkstra on a given graph defined via a adjacency matrix. Keep track
/// of the parents to each node on the path.
///
/// Arguments:
///   - `T`: Type of the weigths in the adjacency matrix.
///   - `adjacency_matrix`: The adjacency matrix of the graph.
///   - `start`: Start node.
///   - `end`: End node.
///   - `quick_return`: Whether to return as soon as the shortest path is found.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - The maze object.
pub fn dijkstra(
    comptime T: type,
    adjacency_matrix: ArrayList(?T),
    start: usize,
    end: usize,
    quick_return: bool,
    allocator: Allocator,
) !ArrayList(DijkstraNode(T)) {
    const size = std.math.sqrt(adjacency_matrix.items.len);
    if (size * size != adjacency_matrix.items.len) {
        return error.AdjacencyMatrixNotSquare;
    }
    if (start >= size or end >= size) {
        return error.OutOfBounds;
    }

    // Init nodes
    var nodes = ArrayList(DijkstraNode(T)).init(allocator);
    try nodes.resize(size);
    for (0..size) |idx| {
        nodes.items[idx] = DijkstraNode(T){
            .idx = idx,
            .distance = std.math.maxInt(T),
            .visited = false,
            .parents = ArrayList(*DijkstraNode(T)).init(allocator),
        };
    }

    // Init queue
    var pq = PriorityQueue(
        *DijkstraNode(T),
        void,
        dijkstraLessThan(T, void),
    ).init(allocator, {});
    nodes.items[start].distance = 0;
    try pq.add(&nodes.items[start]);

    while (pq.count() > 0) {
        var current = pq.remove();
        if (current.visited) {
            continue;
        }
        current.visited = true;

        if (quick_return and current.idx == end) {
            return nodes;
        }

        for (nodes.items) |*neighbour| {
            if (neighbour.visited) {
                continue;
            }

            if (adjacency_matrix.items[current.idx * size + neighbour.idx]) |weight| {
                const new_distance = current.distance + weight;
                if (new_distance <= neighbour.distance) {
                    try neighbour.parents.append(current);
                    if (new_distance < neighbour.distance) {
                        neighbour.distance = new_distance;
                        try pq.add(neighbour);
                    }
                }
            }
        }
    }

    return nodes;
}

/// Assemble a set of nodes that are on any shortest path.
///
/// Arguments:
///   - `T`: Type of the weigths in the adjacency matrix.
///   - `nodes`: List of dijkstra nodes (returned by a dijkstra call).
///   - `end`: End node.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - A set of nodes that are on any shortest path.
pub fn get_path_nodes(
    comptime T: type,
    nodes: ArrayList(DijkstraNode(T)),
    end: usize,
    allocator: Allocator,
) !HashMap(usize, void) {
    var path_nodes = HashMap(usize, void).init(allocator);
    try path_nodes.put(end, {});
    var found_path_node = true;
    while (found_path_node) {
        found_path_node = false;
        for (path_nodes.keys()) |idx| {
            for (nodes.items[idx].parents.items) |parent| {
                if (!path_nodes.contains(parent.idx)) {
                    try path_nodes.put(parent.idx, {});
                    found_path_node = true;
                }
            }
            if (found_path_node) {
                break;
            }
        }
    }

    return path_nodes;
}
