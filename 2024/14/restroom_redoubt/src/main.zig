const std = @import("std");
const yazap = @import("yazap");
const restroom_redoubt = @import("restroom_redoubt");

const allocator = std.heap.page_allocator;
const log = std.log;
const App = yazap.App;
const Arg = yazap.Arg;
const string = []const u8;

pub fn main() !void {
    var app = App.init(
        allocator,
        "restroom_redoubt",
        "Day 14: Restroom Redoubt",
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
        "seconds",
        's',
        "Seconds to simulate",
    ));
    try cmd.addArg(Arg.singleValueOption(
        "x-dim",
        'x',
        "Size of x dimension",
    ));
    try cmd.addArg(Arg.singleValueOption(
        "y-dim",
        'y',
        "Size of y dimension",
    ));
    try cmd.addArg(Arg.booleanOption(
        "print",
        'p',
        "Whether to print the picture of the christmas tree",
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

    var seconds: i32 = undefined;
    if (matches.getSingleValue("seconds")) |sec| {
        seconds = try std.fmt.parseInt(i32, sec, 10);
    } else {
        try app.displayHelp();
        return;
    }

    var dim_x: i32 = undefined;
    if (matches.getSingleValue("x-dim")) |x_dim| {
        dim_x = try std.fmt.parseInt(i32, x_dim, 10);
    } else {
        try app.displayHelp();
        return;
    }

    var dim_y: i32 = undefined;
    if (matches.getSingleValue("y-dim")) |y_dim| {
        dim_y = try std.fmt.parseInt(i32, y_dim, 10);
    } else {
        try app.displayHelp();
        return;
    }

    const print = matches.containsArg("print");

    const result_1 = restroom_redoubt.security_factor(
        file_content,
        seconds,
        dim_x,
        dim_y,
        allocator,
    );
    try stdout.print("Security factor: {!}\n", .{result_1});
    try bw.flush();

    const result_2 = restroom_redoubt.time_until_christmas_tree(
        file_content,
        dim_x,
        dim_y,
        print,
        allocator,
    );
    try stdout.print("Seconds until the christmas tree appears: {!}\n", .{result_2});
    try bw.flush();
}
