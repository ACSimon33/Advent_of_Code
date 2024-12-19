const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const string = []const u8;

/// Task 1 - Count the number of fully safe reports.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Number of fully safe reports.
pub fn number_of_safe_reports(contents: string, main_allocator: Allocator) !i32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const reports: ArrayList(Report) = try parse_reports(contents, allocator);

    var safe_reports: i32 = 0;
    for (reports.items) |report| {
        if (try is_report_safe(report, null)) {
            safe_reports += 1;
        }
    }

    return safe_reports;
}

/// Task 2 - Count the number of partially safe reports
///          (safe when one entry is removed).
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Number of fully safe reports.
pub fn number_of_partially_safe_reports(contents: string, main_allocator: Allocator) !i32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const reports: ArrayList(Report) = try parse_reports(contents, allocator);

    var safe_reports: i32 = 0;
    for (reports.items) |report| {
        var safe = false;
        for (0..reports.items.len) |i| {
            safe = safe or try is_report_safe(report, i);
        }
        if (safe) {
            safe_reports += 1;
        }
    }

    return safe_reports;
}

// -------------------------------------------------------------------------- \\

// Report containing a list of levels.
const Report = struct {
    levels: ArrayList(i32),
};

/// Parse the file contents into a list of reports.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array list of report objects.
fn parse_reports(contents: string, allocator: Allocator) !ArrayList(Report) {
    var reports = ArrayList(Report).init(allocator);

    var lines = std.mem.tokenize(u8, contents, "\r\n");
    while (lines.next()) |line| {
        var levels = ArrayList(i32).init(allocator);
        var report_str = std.mem.split(u8, line, " ");
        while (report_str.next()) |level_str| {
            try levels.append(try std.fmt.parseInt(i32, level_str, 10));
        }
        try reports.append(Report{ .levels = levels });
    }

    return reports;
}

/// Checks if a given report is safe based on its levels and an optional index to skip.
///
/// This function iterates through the levels of the report and checks the differences
/// between consecutive levels. A report is considered safe if:
/// - The absolute difference between consecutive levels is between 1 and 3 (inclusive).
/// - The differences do not change sign (i.e., they are either all positive or all negative).
///
/// If an optional index to skip is provided, the level at that index is ignored during the checks.
///
/// Parameters:
///   - `report`: The report to be checked, containing levels.
///   - `skip`: An optional index to skip during the checks.
///
/// Returns:
///   - Whether the report is safe.
fn is_report_safe(report: Report, skip: ?usize) !bool {
    var current_difference: ?i32 = null;
    var current_level: ?i32 = null;

    for (report.levels.items, 0..) |level, idx| {
        if (skip) |skip_idx| {
            if (skip_idx == idx) {
                continue;
            }
        }

        if (current_level == null) {
            current_level = level;
            continue;
        }

        const difference: i32 = current_level.? - level;
        current_level = level;

        if (@abs(difference) < 1 or @abs(difference) > 3) {
            return false;
        }

        if (current_difference == null) {
            current_difference = difference;
            continue;
        }

        if ((current_difference.? < 0 and difference > 0) or (current_difference.? > 0 and difference < 0)) {
            return false;
        }

        current_difference = difference;
    }

    return true;
}
