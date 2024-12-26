const std = @import("std");
const yazap = @import("yazap");
const race_condition = @import("race_condition");

const allocator = std.heap.page_allocator;
const log = std.log;
const App = yazap.App;
const Arg = yazap.Arg;
const string = []const u8;

pub fn main() !void {
    var app = App.init(
        allocator,
        "race_condition",
        "Day 20: Race Condition",
    );
    defer app.deinit();

    var cmd = app.rootCommand();
    cmd.setProperty(.help_on_empty_args);
    try cmd.addArg(Arg.singleValueOption(
        "filename",
        'f',
        "Input file (e.g. input/puzzle_input.txt)",
    ));
    try cmd.addArg(Arg.singleValueOption(
        "shortcut",
        's',
        "Minimal shortcut size",
    ));

    const matches = try app.parseProcess();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var file_content: string = undefined;
    if (matches.getSingleValue("filename")) |filename| {
        const file = try std.fs.cwd().openFile(filename, .{});
        defer file.close();

        const file_size = try file.getEndPos();
        const buffer: []u8 = try allocator.alloc(u8, file_size);
        defer allocator.free(buffer);

        _ = try file.readAll(buffer);
        file_content = std.mem.Allocator.dupe(
            allocator,
            u8,
            std.mem.trim(u8, buffer, "\n"),
        ) catch unreachable;
    } else {
        try app.displayHelp();
        return;
    }

    var min_shortcut: usize = undefined;
    if (matches.getSingleValue("shortcut")) |shortcut| {
        min_shortcut = try std.fmt.parseInt(usize, shortcut, 10);
    } else {
        try app.displayHelp();
        return;
    }

    const result_1 = race_condition.amount_of_shortcuts(
        file_content,
        2,
        min_shortcut,
        allocator,
    );
    try stdout.print("Amount of shortcuts with a range of 2: {!}\n", .{result_1});
    try bw.flush();

    const result_2 = race_condition.amount_of_shortcuts(
        file_content,
        20,
        min_shortcut,
        allocator,
    );
    try stdout.print("Amount of shortcuts with a range of 20: {!}\n", .{result_2});
    try bw.flush();
}
