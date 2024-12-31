const std = @import("std");
const yazap = @import("yazap");
const keypad_conundrum = @import("keypad_conundrum");

const allocator = std.heap.page_allocator;
const log = std.log;
const App = yazap.App;
const Arg = yazap.Arg;
const string = []const u8;

pub fn main() !void {
    var app = App.init(
        allocator,
        "keypad_conundrum",
        "Day 21: Keypad Conundrum",
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
        "robots",
        'r',
        "Amount of robots",
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

    var robots: usize = undefined;
    if (matches.getSingleValue("robots")) |robots_str| {
        robots = try std.fmt.parseInt(u8, robots_str, 10);
    } else {
        try app.displayHelp();
        return;
    }

    const result_1 = keypad_conundrum.number_of_keys(
        file_content,
        robots,
        allocator,
    );
    try stdout.print("Amount of keystrokes: {!}\n", .{result_1});
    try bw.flush();
}
