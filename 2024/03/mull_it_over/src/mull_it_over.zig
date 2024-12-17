const std = @import("std");
const Allocator = std.mem.Allocator;
const string = []const u8;

/// Task 1 - Calculate the sum over all multiplication instructions.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Sum of all multiplications.
pub fn sum_of_multiplication_instructions(contents: string, _: Allocator) !u32 {
    const min_instruction_len: usize = 8;

    var product_sum: u32 = 0;
    var i: usize = 0;
    while (i <= contents.len - min_instruction_len) {
        product_sum += parse_mul_instruction(contents, &i) catch {
            continue;
        };
    }

    return product_sum;
}

/// Task 2 - Calculate the sum over the multiplication instructions which are
///          activated via the do() instructions.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Sum of all active multiplications.
pub fn conditional_sum_of_multiplication_instructions(contents: string, _: Allocator) !u32 {
    const min_instruction_len: usize = 8;

    var product_sum: u32 = 0;
    var do: bool = true;
    var i: usize = 0;
    while (i <= contents.len - min_instruction_len) {
        do = parse_conditional_instructions(contents, &i) catch do;
        if (do) {
            product_sum += parse_mul_instruction(contents, &i) catch {
                continue;
            };
        } else {
            i += 1;
        }
    }

    return product_sum;
}

// -------------------------------------------------------------------------- \\

/// Parse a single multiplication instruction.
///
/// Arguments:
///   - `contents`: The instruction string.
///   - `i`: Pointer to the current position in the instruction string.
///
/// Returns:
///   - The result of the multiplication instruction if one was found.
fn parse_mul_instruction(contents: string, i: *usize) !u32 {
    if (!std.mem.eql(u8, contents[(i.*)..(i.* + 4)], "mul(")) {
        i.* += 1;
        return error.InvalidInstruction;
    }
    i.* += 4;

    const multiplier = try parse_three_digit_number(contents[(i.*)..(i.* + 3)], i);
    if (contents[i.*] != ',') {
        return error.InvalidInstruction;
    }
    i.* += 1;

    const multiplicand = try parse_three_digit_number(contents[(i.*)..(i.* + 3)], i);
    if (contents[i.*] != ')') {
        return error.InvalidInstruction;
    }
    i.* += 1;

    return multiplier * multiplicand;
}

/// Parse a single integer up to three digits.
///
/// Arguments:
///   - `contents`: The instruction string.
///   - `i`: Pointer to the current position in the instruction string.
///
/// Returns:
///   - The integer if one was found.
fn parse_three_digit_number(str: string, i: *usize) !u32 {
    var num = try std.fmt.parseInt(u32, str[0..1], 10);
    i.* += 1;

    if (str[1] != ',' and str[1] != ')') {
        num *= 10;
        num += try std.fmt.parseInt(u32, str[1..2], 10);
    } else {
        return num;
    }
    i.* += 1;

    if (str[2] != ',' and str[2] != ')') {
        num *= 10;
        num += try std.fmt.parseInt(u32, str[2..3], 10);
    } else {
        return num;
    }
    i.* += 1;

    return num;
}

/// Parse a single conditional instruction: do() or don't().
///
/// Arguments:
///   - `contents`: The instruction string.
///   - `i`: Pointer to the current position in the instruction string.
///
/// Returns:
///   - The true if do() was found and false if don't() was found.
fn parse_conditional_instructions(contents: string, i: *usize) !bool {
    if (std.mem.eql(u8, contents[(i.*)..(i.* + 4)], "do()")) {
        i.* += 4;
        return true;
    }

    if (std.mem.eql(u8, contents[(i.*)..(i.* + 7)], "don't()")) {
        i.* += 7;
        return false;
    }

    return error.InvalidInstruction;
}
