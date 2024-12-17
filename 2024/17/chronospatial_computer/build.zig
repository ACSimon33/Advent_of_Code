const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const chronospatial_computer = b.addModule("chronospatial_computer", .{
        .root_source_file = b.path("src/chronospatial_computer.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const chronospatial_computer_exe = b.addExecutable(.{
        .name = "chronospatial_computer",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    chronospatial_computer_exe.root_module.addImport("yazap", yazap.module("yazap"));
    chronospatial_computer_exe.root_module.addImport("chronospatial_computer", chronospatial_computer);
    b.installArtifact(chronospatial_computer_exe);

    const run_cmd = b.addRunArtifact(chronospatial_computer_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Chronospatial Computer (day 17) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const chronospatial_computer_tests = b.addTest(.{
        .name = "chronospatial_computer_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    chronospatial_computer_tests.root_module.addImport("chronospatial_computer", chronospatial_computer);
    inline for (1..3) |i| {
        const num_str = std.fmt.comptimePrint("{!}", .{i});
        chronospatial_computer_tests.root_module.addAnonymousImport(
            "example_input_" ++ num_str,
            .{
                .root_source_file = b.path("input/example_input_" ++ num_str ++ ".txt"),
            },
        );
    }
    b.installArtifact(chronospatial_computer_tests);

    const test_step = b.step("test", "Run Chronospatial Computer (day 17) tests");
    test_step.dependOn(&b.addRunArtifact(chronospatial_computer_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const chronospatial_computer_benchmarks = b.addExecutable(.{
        .name = "chronospatial_computer_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    chronospatial_computer_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    chronospatial_computer_benchmarks.root_module.addImport("chronospatial_computer", chronospatial_computer);
    chronospatial_computer_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(chronospatial_computer_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Chronospatial Computer (day 17) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(chronospatial_computer_benchmarks).step);
}
