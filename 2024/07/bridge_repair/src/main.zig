const std = @import("std");
const yazap = @import("yazap");
const bridge_repair = @import("bridge_repair");

const allocator = std.heap.page_allocator;
const log = std.log;
const App = yazap.App;
const Arg = yazap.Arg;
const string = []const u8;

pub fn main() !void {
    var app = App.init(
        allocator,
        "bridge_repair",
        "Day 07: Bridge Repair",
    );
    defer app.deinit();

    var cmd = app.rootCommand();
    cmd.setProperty(.help_on_empty_args);
    try cmd.addArg(Arg.singleValueOption(
        "filename",
        'f',
        "Input file (e.g. input/puzzle_input.txt)",
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

    const result_1 = bridge_repair.total_calibration_result(
        file_content,
        allocator,
    );
    try stdout.print("Total calibration result (+, *): {!}\n", .{result_1});
    try bw.flush();

    const result_2 = bridge_repair.total_calibration_result_with_concatenation(
        file_content,
        allocator,
    );
    try stdout.print("Total calibration result (+, *, ||): {!}\n", .{result_2});
    try bw.flush();
}
