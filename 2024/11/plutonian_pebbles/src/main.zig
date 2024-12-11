const std = @import("std");
const yazap = @import("yazap");
const plutonian_pebbles = @import("plutonian_pebbles");

const allocator = std.heap.page_allocator;
const log = std.log;
const App = yazap.App;
const Arg = yazap.Arg;
const string = []const u8;

pub fn main() !void {
    var app = App.init(allocator, "Day 11", "Day 11: Plutonian Pebbles");
    defer app.deinit();

    var cmd = app.rootCommand();
    cmd.setProperty(.help_on_empty_args);
    try cmd.addArg(Arg.singleValueOption(
        "filename",
        'f',
        "Input file (e.g. input/puzzle_input.txt)",
    ));
    try cmd.addArg(Arg.singleValueOption(
        "blinks",
        'b',
        "Amount of blinks",
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

    var blinks: usize = undefined;
    if (matches.getSingleValue("blinks")) |blinks_str| {
        blinks = try std.fmt.parseInt(usize, blinks_str, 10);
    } else {
        try app.displayHelp();
        return;
    }

    const result = plutonian_pebbles.amount_of_stones(file_content, blinks);
    try stdout.print("Amount of stones: {!}\n", .{result});
    try bw.flush();
}
