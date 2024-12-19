const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const string = []const u8;

/// Task 1 - Check each page update if it obeys all page numbering rules. For
///          those that do, sum up the middle page numbers.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Sum of the middle page numbers
pub fn middle_page_sum_of_valid_updates(contents: string, main_allocator: Allocator) !u32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const rules, const updates = try parse(contents, allocator);

    var middle_page_numbers: u32 = 0;
    for (updates.items) |update| {
        var valid = true;
        for (rules.items) |rule| {
            valid = valid and update.validate(rule);
        }

        if (valid) {
            middle_page_numbers += update.middle_page_number();
        }
    }

    return middle_page_numbers;
}

/// Task 2 - Check each page update if it obeys all page numbering rules. Fix
///          those that break the rules, and sum the middle page numbers of the
///          fixed updates.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Sum of the middle page numbers
pub fn middle_page_sum_of_fixed_updates(contents: string, main_allocator: Allocator) !u32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const rules, const updates = try parse(contents, allocator);

    var middle_page_numbers: u32 = 0;
    for (updates.items) |update| {
        var fixed = false;
        var still_broken = true;

        // Apply rules until the update is valid (this should always converge
        // to a valid update, I think)
        while (still_broken) {
            still_broken = false;
            for (rules.items) |rule| {
                if (!update.validate(rule)) {
                    update.apply(rule);
                    fixed = true;
                    still_broken = true;
                    break;
                }
            }
        }

        if (fixed) {
            middle_page_numbers += update.middle_page_number();
        }
    }

    return middle_page_numbers;
}

// -------------------------------------------------------------------------- \\

/// Page number ordering rule.
const Rule = struct {
    first: u32,
    second: u32,
};

/// The page update consisting of a list of page numbers that are printed.
const Update = struct {
    pages: ArrayList(u32),

    /// Return the page number of the middle page.
    ///
    /// Arguments:
    ///   - `self`: The Update object.
    ///
    /// Returns:
    ///   - The page number of the middle page.
    fn middle_page_number(self: Update) u32 {
        return self.pages.items[self.pages.items.len / 2];
    }

    /// Check if the update adheres to the given rule.
    ///
    /// Arguments:
    ///   - `self`: The Update object.
    ///   - `rule`: The rule we want to check.
    ///
    /// Returns:
    ///   - True if the update obeys the rule.
    fn validate(self: Update, rule: Rule) bool {
        if (std.mem.indexOfScalar(u32, self.pages.items, rule.first)) |idx_1| {
            if (std.mem.indexOfScalar(u32, self.pages.items, rule.second)) |idx_2| {
                return idx_1 < idx_2;
            }
        }
        return true;
    }

    /// Apply the given rule to the update, i.e. swap the pages that break
    /// the rule.
    ///
    /// Arguments:
    ///   - `self`: The Update object.
    ///   - `rule`: The rule we want to apply.
    fn apply(self: Update, rule: Rule) void {
        if (std.mem.indexOfScalar(u32, self.pages.items, rule.first)) |idx_1| {
            if (std.mem.indexOfScalar(u32, self.pages.items, rule.second)) |idx_2| {
                if (idx_2 < idx_1) {
                    std.mem.swap(u32, &self.pages.items[idx_1], &self.pages.items[idx_2]);
                }
            }
        }
    }
};

/// Parse the file contents into lists of rules and updates.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array lists of ordering rules and page updates.
fn parse(contents: string, allocator: Allocator) !struct { ArrayList(Rule), ArrayList(Update) } {
    var rules = ArrayList(Rule).init(allocator);
    var updates = ArrayList(Update).init(allocator);

    var lines = std.mem.tokenize(
        u8,
        contents,
        "\n\r",
    );
    while (lines.next()) |line| {
        if (std.mem.count(u8, line, "|") == 1) {
            var rule_numbers = std.mem.split(
                u8,
                line,
                "|",
            );
            try rules.append(Rule{
                .first = try std.fmt.parseInt(u32, rule_numbers.next().?, 10),
                .second = try std.fmt.parseInt(u32, rule_numbers.next().?, 10),
            });
        } else {
            var pages_numbers = std.mem.split(
                u8,
                line,
                ",",
            );
            var pages = ArrayList(u32).init(allocator);
            while (pages_numbers.next()) |page_str| {
                try pages.append(try std.fmt.parseInt(u32, page_str, 10));
            }
            try updates.append(Update{ .pages = pages });
        }
    }

    return .{ rules, updates };
}
