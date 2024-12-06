const std = @import("std");
const yazap = @import("yazap");
const guard_gallivant = @import("guard_gallivant");

const allocator = std.heap.page_allocator;
const log = std.log;
const App = yazap.App;
const Arg = yazap.Arg;

pub fn main() !void {
    var app = App.init(allocator, "Day 06", "Day 06: Guard Gallivant");
    defer app.deinit();

    var cmd = app.rootCommand();
    cmd.setProperty(.help_on_empty_args);
    try cmd.addArg(Arg.singleValueOption("filename", 'f', "Input file (e.g. input/puzzle_input.txt)"));

    const matches = try app.parseProcess();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var file_content: []u8 = &[_]u8{};

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

    const result_1 = guard_gallivant.solution_1(file_content);
    try stdout.print("1. Solution: {!}\n", .{result_1});
    try bw.flush();

    const result_2 = guard_gallivant.solution_2(file_content);
    try stdout.print("2. Solution: {!}\n", .{result_2});
    try bw.flush();
}
