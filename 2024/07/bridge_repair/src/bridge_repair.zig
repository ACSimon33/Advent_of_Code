const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const string = []const u8;
const OpType = *const fn (a: u64, b: u64) anyerror!u64;

/// Task 1 - Calculate the total calibration results by checking which
///          equations are valid using addition and multiplication operators.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - The total calibration results.
pub fn total_calibration_result(contents: string, main_allocator: Allocator) !u64 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const equations = try parse_equations(contents, allocator);

    var operators = ArrayList(OpType).init(allocator);
    try operators.append(add_operator);
    try operators.append(mul_operator);

    var calibration_result: u64 = 0;
    for (equations.items) |equation| {
        if (try equation.validate(operators)) {
            calibration_result += equation.test_value;
        }
    }

    return calibration_result;
}

/// Task 2 - Calculate the total calibration results by checking which
///          equations are valid using addition, multiplication, and
///          concatrnation operators.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - The total calibration results.
pub fn total_calibration_result_with_concatenation(contents: string, main_allocator: Allocator) !u64 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const equations = try parse_equations(contents, allocator);

    var operators = ArrayList(OpType).init(allocator);
    try operators.append(add_operator);
    try operators.append(mul_operator);
    try operators.append(concat_operator);

    var calibration_result: u64 = 0;
    for (equations.items) |equation| {
        if (try equation.validate(operators)) {
            calibration_result += equation.test_value;
        }
    }

    return calibration_result;
}

// -------------------------------------------------------------------------- \\

// Calibration equation that might be valid with a given set of operators.
const Equation = struct {
    test_value: u64,
    operands: ArrayList(u64),

    /// Check if there is a selection of operators that make the equation valid.
    ///
    /// Arguments:
    ///   - `self`: The equation to check.
    ///   - `operators`: The available operators.
    ///
    /// Returns:
    ///   - True if there exists a selection of operators which make the
    ///     equation valid.
    fn validate(self: Equation, operators: ArrayList(OpType)) !bool {
        return try self.try_operators(
            operators,
            1,
            self.operands.items[0],
        );
    }

    /// Check if there is a selection of operators that make the equation valid.
    /// We recursively try operators until we used all operands.
    ///
    /// Arguments:
    ///   - `self`: The equation to check.
    ///   - `operators`: The available operators.
    ///   - `operand_idx`: The index of the current operands.
    ///   - `total`: The current result of the equation.
    ///
    /// Returns:
    ///   - True if there exists a selection of operators which make the
    ///     equation valid.
    fn try_operators(
        self: Equation,
        operators: ArrayList(OpType),
        operand_idx: usize,
        total: u64,
    ) !bool {
        if (total > self.test_value) {
            return false;
        }
        if (operand_idx < self.operands.items.len) {
            var found_match = false;
            for (operators.items) |op| {
                found_match = found_match or try self.try_operators(
                    operators,
                    operand_idx + 1,
                    try op(total, self.operands.items[operand_idx]),
                );
            }
            return found_match;
        }

        return total == self.test_value;
    }
};

/// Addition operator.
///
/// Arguments:
///   - `a`: Augend.
///   - `b`: Addend.
///
/// Returns:
///   - Sum of the two numbers.
fn add_operator(a: u64, b: u64) !u64 {
    return try std.math.add(u64, a, b);
}

/// Multiplication operator.
///
/// Arguments:
///   - `a`: Multiplier.
///   - `b`: Multiplicand.
///
/// Returns:
///   - Product of the two numbers.
fn mul_operator(a: u64, b: u64) !u64 {
    return try std.math.mul(u64, a, b);
}

/// Concatenation operator.
///
/// Arguments:
///   - `a`: First number.
///   - `b`: Second number.
///
/// Returns:
///   - Concatenation of the two numbers.
fn concat_operator(a: u64, b: u64) !u64 {
    const factor: u64 = std.math.log10_int(b) + 1;
    return (try std.math.powi(u64, 10, factor)) * a + b;
}

/// Parse the file contents into a list of calibration equations.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array list of equation objects.
fn parse_equations(contents: string, allocator: Allocator) !ArrayList(Equation) {
    var equations = ArrayList(Equation).init(allocator);

    var lines = std.mem.tokenize(u8, contents, "\r\n");
    while (lines.next()) |line| {
        var numbers = std.mem.tokenize(u8, line, ": ");
        var equation = Equation{
            .test_value = try std.fmt.parseInt(u64, numbers.next().?, 10),
            .operands = ArrayList(u64).init(allocator),
        };

        while (numbers.next()) |num| {
            try equation.operands.append(try std.fmt.parseInt(u64, num, 10));
        }
        try equations.append(equation);
    }

    return equations;
}
