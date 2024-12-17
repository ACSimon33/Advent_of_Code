const std = @import("std");
const yazap = @import("yazap");
const disk_fragmenter = @import("disk_fragmenter");

const allocator = std.heap.page_allocator;
const log = std.log;
const App = yazap.App;
const Arg = yazap.Arg;
const string = []const u8;

pub fn main() !void {
    var app = App.init(
        allocator,
        "disk_fragmenter",
        "Day 09: Disk Fragmenter",
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

    const result_1 = disk_fragmenter.checksum_of_fragmented_disk(
        file_content,
        allocator,
    );
    try stdout.print("Checksum of fragmented compressed disk: {!}\n", .{result_1});
    try bw.flush();

    const result_2 = disk_fragmenter.checksum_of_defragmented_disk(
        file_content,
        allocator,
    );
    try stdout.print("Checksum of defragmented compressed disk: {!}\n", .{result_2});
    try bw.flush();
}
