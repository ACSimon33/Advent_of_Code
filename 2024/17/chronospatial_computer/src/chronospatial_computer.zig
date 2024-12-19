const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const string = []const u8;

/// Task 1 - Simulate the given program with the given initial values for the
///          registers of the computer.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Program output as a string.
pub fn simulate_program(contents: string, main_allocator: Allocator) !string {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    var computer, const program = try parse_program(contents, allocator);
    const output = try computer.run_program(program, allocator);

    return try program_to_string(output, main_allocator);
}

/// Task 2 - Determine the initial value of register A such that the program
///          outputs itself.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Initial value for register A.
pub fn debug_program(contents: string, main_allocator: Allocator) !u64 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    var computer, const program = try parse_program(contents, allocator);

    return computer.debug_program(program, allocator);
}

// -------------------------------------------------------------------------- \\

// Register indices
const A: usize = 0;
const B: usize = 1;
const C: usize = 2;

/// Instruction types.
const Instruction = enum(u4) { adv, bxl, bst, jnz, bxc, out, bdv, cdv };

/// Computer which can run or debug a given program.
const Computer = struct {
    registers: [3]u64,

    /// Convert an instruction into a combo operand. If the instruction value
    /// is between 0-3, the value is returned, otherwise the current value of
    /// one of the registers is returned.
    ///
    /// Arguments:
    ///   - `self`: The computer object (mutable).
    ///   - `program`: List of instructions.
    ///   - `allocator`: Allocator for the list of outputs.
    ///
    /// Returns:
    ///   - The list of outputs.
    fn run_program(
        self: *Computer,
        program: ArrayList(Instruction),
        allocator: Allocator,
    ) !ArrayList(Instruction) {
        var output = ArrayList(Instruction).init(allocator);
        var ip: u64 = 0;

        while (ip < program.items.len - 1) {
            const op: Instruction = program.items[ip];
            const literal: u64 = @intFromEnum(program.items[ip + 1]);
            const combo: u64 = try self.combo_operand(program.items[ip + 1]);

            switch (op) {
                Instruction.adv => {
                    self.registers[A] >>= @intCast(combo);
                },
                Instruction.bxl => {
                    self.registers[B] ^= literal;
                },
                Instruction.bst => {
                    self.registers[B] = combo % 8;
                },
                Instruction.jnz => {
                    if (self.registers[A] > 0) {
                        ip = literal;
                        continue;
                    }
                },
                Instruction.bxc => {
                    self.registers[B] ^= self.registers[C];
                },
                Instruction.out => {
                    try output.append(@enumFromInt(combo % 8));
                },
                Instruction.bdv => {
                    self.registers[B] = self.registers[A] >> @intCast(combo);
                },
                Instruction.cdv => {
                    self.registers[C] = self.registers[A] >> @intCast(combo);
                },
            }

            ip += 2;
        }

        return output;
    }

    /// Debug the program by figuring out the value that the register A needs to
    /// be initialized with, such that the program outputs itself.
    ///
    /// Arguments:
    ///   - `self`: The computer object (mutable).
    ///   - `program`: List of instructions.
    ///   - `allocator`: Allocator for the list of outputs.
    ///
    /// Returns:
    ///   - The necessary value of register A.
    fn debug_program(self: *Computer, program: ArrayList(Instruction), allocator: Allocator) !u64 {
        return (try self.determine_next_bits(
            program,
            allocator,
            0,
            program.items.len - 1,
        )).?;
    }

    /// The program consumes 3 bits of the value of A in each iteration. We can
    /// shift the current initial value of A by three bits and try all 8
    /// possible values (000-111) for the last 3 bits in order to match the
    /// output with the program instructions.
    ///
    /// Arguments:
    ///   - `self`: The computer object (mutable).
    ///   - `program`: List of instructions.
    ///   - `allocator`: Allocator for the list of outputs.
    ///   - `current_a`: Current initial value for register A.
    ///   - `out_idx`: Output index we try to match.
    ///
    /// Returns:
    ///   - The necessary value of register A or null if no possible value was
    ///     found.
    fn determine_next_bits(
        self: *Computer,
        program: ArrayList(Instruction),
        allocator: Allocator,
        current_a: u64,
        out_idx: usize,
    ) !?u64 {
        var a = current_a << 3;
        for (0..8) |last_bits| {
            a &= (std.math.maxInt(u64) - 7);
            a += last_bits;

            self.registers[A] = a;
            self.registers[B] = 0;
            self.registers[C] = 0;

            const output = try self.run_program(program, allocator);
            defer output.deinit();
            if (std.mem.eql(Instruction, output.items, program.items[out_idx..])) {
                if (out_idx == 0) {
                    return a;
                }
                if (try self.determine_next_bits(program, allocator, a, out_idx - 1)) |final_a| {
                    return final_a;
                }
            }
        }

        return null;
    }

    /// Convert an instruction into a combo operand. If the instruction value
    /// is between 0-3, the value is returned, otherwise the current value of
    /// one of the registers is returned.
    ///
    /// Arguments:
    ///   - `self`: The computer object.
    ///   - `op`: The instruction / operand.
    ///
    /// Returns:
    ///   - The value of the combo operand.
    fn combo_operand(self: Computer, op: Instruction) !u64 {
        const operand: u64 = @intFromEnum(op);
        return switch (operand) {
            0...3 => operand,
            4 => self.registers[A],
            5 => self.registers[B],
            6 => self.registers[C],
            else => {
                return error.InvalidOperand;
            },
        };
    }
};

/// Convert a given program into a string, i.e. the instructions separated
/// by commas.
///
/// Arguments:
///   - `program`: List of instructions.
///   - `allocator`: Allocator for the string.
///
/// Returns:
///   - String representation of the program / instructions.
fn program_to_string(program: ArrayList(Instruction), allocator: Allocator) !string {
    var out_str = try allocator.alloc(u8, 2 * program.items.len - 1);
    for (program.items, 0..) |out, i| {
        _ = try std.fmt.bufPrint(out_str[2 * i ..], "{!}", .{@intFromEnum(out)});
        if (2 * i + 1 < 2 * program.items.len - 1) {
            out_str[2 * i + 1] = ',';
        }
    }
    return out_str;
}

/// Parse the file contents into a computer with initialized registers and a
/// program consisting of a list of instructions.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Computer and array list of instructions.
fn parse_program(contents: string, allocator: Allocator) !struct { Computer, ArrayList(Instruction) } {
    var program = ArrayList(Instruction).init(allocator);
    var registers = [3]u64{ 0, 0, 0 };

    var lines = std.mem.tokenize(u8, contents, "\r\n");
    if (lines.next()) |reg_A| {
        registers[A] = try std.fmt.parseInt(u64, reg_A["Register A: ".len..], 10);
    }
    if (lines.next()) |reg_B| {
        registers[B] = try std.fmt.parseInt(u64, reg_B["Register B: ".len..], 10);
    }
    if (lines.next()) |reg_C| {
        registers[C] = try std.fmt.parseInt(u64, reg_C["Register C: ".len..], 10);
    }
    if (lines.next()) |prog| {
        var ops = std.mem.tokenize(u8, prog["Program: ".len..], ",");
        while (ops.next()) |op| {
            try program.append(@enumFromInt(try std.fmt.parseInt(u4, op, 10)));
        }
    }

    return .{ Computer{ .registers = registers }, program };
}
