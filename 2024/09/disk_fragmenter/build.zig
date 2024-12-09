const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const disk_fragmenter = b.addModule("disk_fragmenter", .{
        .root_source_file = b.path("src/disk_fragmenter.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const disk_fragmenter_exe = b.addExecutable(.{
        .name = "disk_fragmenter",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    disk_fragmenter_exe.root_module.addImport("yazap", yazap.module("yazap"));
    disk_fragmenter_exe.root_module.addImport("disk_fragmenter", disk_fragmenter);
    b.installArtifact(disk_fragmenter_exe);

    const run_cmd = b.addRunArtifact(disk_fragmenter_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the disk_fragmenter (day 09) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const disk_fragmenter_tests = b.addTest(.{
        .name = "disk_fragmenter_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    disk_fragmenter_tests.root_module.addImport("disk_fragmenter", disk_fragmenter);
    disk_fragmenter_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(disk_fragmenter_tests);

    const test_step = b.step("test", "Run disk_fragmenter (day 09) tests");
    test_step.dependOn(&b.addRunArtifact(disk_fragmenter_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const disk_fragmenter_benchmarks = b.addExecutable(.{
        .name = "disk_fragmenter_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    disk_fragmenter_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    disk_fragmenter_benchmarks.root_module.addImport("disk_fragmenter", disk_fragmenter);
    disk_fragmenter_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(disk_fragmenter_benchmarks);

    const benchmark_step = b.step("benchmark", "Run disk_fragmenter (day 09) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(disk_fragmenter_benchmarks).step);
}
