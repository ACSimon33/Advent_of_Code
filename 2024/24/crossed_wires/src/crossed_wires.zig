const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const HashMap = std.AutoArrayHashMap;
const string = []const u8;

/// Task 1 - Simulate the gates with the given inputs.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - The number represented by the output gates (z).
pub fn simulate_gates(contents: string, main_allocator: Allocator) !u64 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const gates = try parse(contents, allocator);
    return calculate_z(gates);
}

/// Task 2 - Find the gates that are not correctly connected in the adder. I
///          used some simple rules (see below) to determine wether gate outputs
///          are wrongly labeled. For my input these rules were enough, but for
///          others maybe not.
///
/// Assumptions / facts for the adder:
///   - intermediate gates never start with x, y or z
///   - gate swaps only happen in the same layer!
///   - output gates (z) have for be XOR gates
///   - output gates (z) don't have AND gates as inputs except for z01 and z45
///   - OR gates can only have inputs from AND gates
///   - XOR gates should have x and y as input or be outputs
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Wrongly labeled gates in alphabetical order.
pub fn find_wrong_gates(contents: string, main_allocator: Allocator) !string {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const gates = try parse(contents, allocator);

    var input_bits: u6 = 0;
    var iter = gates.iterator();
    while (iter.next()) |entry| {
        if (entry.key_ptr[0] == 'x' or entry.key_ptr[0] == 'y') {
            input_bits = @max(entry.value_ptr.shift, input_bits);
        }
    }

    var wrong_gates = HashMap([3]u8, void).init(allocator);
    iter.reset();
    while (iter.next()) |entry| {
        if (entry.key_ptr[0] == 'z') {
            if (entry.value_ptr.shift <= input_bits) {
                if (entry.value_ptr.type != GateType.XOR) {
                    try wrong_gates.put(entry.key_ptr.*, {});
                    continue;
                }

                if (entry.value_ptr.shift > 1) {
                    if (entry.value_ptr.input[0].type == GateType.AND) {
                        try wrong_gates.put(entry.value_ptr.input[0].id, {});
                        continue;
                    }

                    if (entry.value_ptr.input[1].type == GateType.AND) {
                        try wrong_gates.put(entry.value_ptr.input[1].id, {});
                        continue;
                    }
                }
            }
        }
        if (entry.value_ptr.type == GateType.XOR) {
            if (entry.key_ptr[0] != 'z' and
                entry.value_ptr.input[0].id[0] != 'x' and
                entry.value_ptr.input[1].id[0] != 'x')
            {
                try wrong_gates.put(entry.key_ptr.*, {});
            }
            continue;
        }
        if (entry.value_ptr.type == GateType.OR) {
            if (entry.value_ptr.input[0].type != GateType.AND) {
                try wrong_gates.put(entry.value_ptr.input[0].id, {});
                continue;
            }

            if (entry.value_ptr.input[1].type != GateType.AND) {
                try wrong_gates.put(entry.value_ptr.input[1].id, {});
                continue;
            }
        }
    }

    std.sort.insertion([3]u8, wrong_gates.keys(), {}, compareStrings);
    const result_str = try main_allocator.alloc(u8, 4*wrong_gates.count()-1);
    for (wrong_gates.keys(), 0..) |id, i| {
        if (i == wrong_gates.count()-1) {
            _ = try std.fmt.bufPrint(result_str[4*i ..], "{s}", .{id});
        } else {
            _ = try std.fmt.bufPrint(result_str[4*i ..], "{s},", .{id});
        }
    }

    return result_str;
}

// -------------------------------------------------------------------------- \\

/// Gate types.
const GateType = enum { IN, AND, OR, XOR };

/// A logic gate.
const Gate = struct {
    id: [3]u8,
    type: GateType,
    input: [2]*Gate,
    output: ?u64,
    shift: u6,

    /// Simulate the gate. If the gate was already simulated just return
    /// the output.
    ///
    /// Arguments:
    ///   - `self`: The gate object.
    ///
    /// Returns:
    ///   - Output value.
    fn eval(self: *Gate) u64 {
        if (self.output) |out| {
            return out;
        }

        switch (self.type) {
            GateType.AND => self.output = self.input[0].eval() & self.input[1].eval(),
            GateType.OR => self.output = self.input[0].eval() | self.input[1].eval(),
            GateType.XOR => self.output = self.input[0].eval() ^ self.input[1].eval(),
            GateType.IN => unreachable,
        }

        return self.output.?;
    }

    /// Simulate the gate and return the shifted output of the gate.
    ///
    /// Arguments:
    ///   - `self`: The gate object.
    ///
    /// Returns:
    ///   - Output value shifted by the shift of the gate, i.e. z30 shifts the
    ///     output bit by 30.
    fn get_shifted_output(self: *Gate) u64 {
        return self.eval() << self.shift;
    }
};

/// Simulate the gates an return the value of z.
///
/// Arguments:
///   - `gates`: Map of the gates.
///
/// Returns:
///   - Value of z.
fn calculate_z(gates: HashMap([3]u8, Gate)) u64 {
    var z: u64 = 0;
    var iter = gates.iterator();
    while (iter.next()) |entry| {
        if (entry.key_ptr[0] == 'z') {
            z += entry.value_ptr.get_shifted_output();
        }
    }
    return z;
}

/// Compare two strings lexicographically.
///
/// Arguments:
///   - `lhs`: Left string.
///   - `rhs`: Right string.
///
/// Returns:
///   - Lexicographical order of the strings (<).
fn compareStrings(_: void, lhs: [3]u8, rhs: [3]u8) bool {
    return std.mem.order(u8, &lhs, &rhs).compare(std.math.CompareOperator.lt);
}

/// Parse the file contents into a map of logic gates.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Map of IDs to logic gates.
fn parse(contents: string, allocator: Allocator) !HashMap([3]u8, Gate) {
    var gates = HashMap([3]u8, Gate).init(allocator);

    // Parse inputs and gates
    var lines = std.mem.tokenize(u8, contents, "\r\n");
    while (lines.next()) |line| {
        if (line[3] == ':') {
            var input = std.mem.split(u8, line, ": ");
            const id: [3]u8 = input.next().?[0..3].*;
            const output = try std.fmt.parseInt(u64, input.next().?, 10);
            try gates.put(id, Gate{
                .id = id,
                .type = GateType.IN,
                .input = [2]*Gate{ undefined, undefined },
                .output = output,
                .shift = try std.fmt.parseInt(u6, id[1..3], 10),
            });
            continue;
        }

        var gate = std.mem.tokenize(u8, line, " ->");
        _ = gate.next();
        const gate_type = switch (gate.next().?[0]) {
            'A' => GateType.AND,
            'O' => GateType.OR,
            'X' => GateType.XOR,
            else => return error.UnknownGateType,
        };
        _ = gate.next();
        const id: [3]u8 = gate.next().?[0..3].*;
        var shift: u6 = 0;
        if (id[0] == 'z') {
            shift = try std.fmt.parseInt(u6, id[1..3], 10);
        }

        try gates.put(id, Gate{
            .id = id,
            .type = gate_type,
            .input = [2]*Gate{ undefined, undefined },
            .output = null,
            .shift = shift,
        });
    }

    // Parse dependencies
    lines.reset();
    while (lines.next()) |line| {
        if (line[3] == ':') {
            continue;
        }

        var gate = std.mem.tokenize(u8, line, " ->");
        const input_id0: [3]u8 = gate.next().?[0..3].*;
        _ = gate.next().?;
        const input_id1: [3]u8 = gate.next().?[0..3].*;
        const id: [3]u8 = gate.next().?[0..3].*;

        gates.getPtr(id).?.input[0] = gates.getPtr(input_id0).?;
        gates.getPtr(id).?.input[1] = gates.getPtr(input_id1).?;
    }

    return gates;
}
