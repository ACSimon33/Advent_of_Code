const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const crossed_wires = b.addModule("crossed_wires", .{
        .root_source_file = b.path("src/crossed_wires.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const crossed_wires_exe = b.addExecutable(.{
        .name = "crossed_wires",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    crossed_wires_exe.root_module.addImport("yazap", yazap.module("yazap"));
    crossed_wires_exe.root_module.addImport("crossed_wires", crossed_wires);
    b.installArtifact(crossed_wires_exe);

    const run_cmd = b.addRunArtifact(crossed_wires_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Crossed Wires (day 24) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const crossed_wires_tests = b.addTest(.{
        .name = "crossed_wires_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    crossed_wires_tests.root_module.addImport("crossed_wires", crossed_wires);
    inline for (1..3) |i| {
        const num_str = std.fmt.comptimePrint("{!}", .{i});
        crossed_wires_tests.root_module.addAnonymousImport(
            "example_input_" ++ num_str,
            .{
                .root_source_file = b.path("input/example_input_" ++ num_str ++ ".txt"),
            },
        );
    }
    b.installArtifact(crossed_wires_tests);

    const test_step = b.step("test", "Run Crossed Wires (day 24) tests");
    test_step.dependOn(&b.addRunArtifact(crossed_wires_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const crossed_wires_benchmarks = b.addExecutable(.{
        .name = "crossed_wires_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    crossed_wires_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    crossed_wires_benchmarks.root_module.addImport("crossed_wires", crossed_wires);
    crossed_wires_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(crossed_wires_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Crossed Wires (day 24) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(crossed_wires_benchmarks).step);
}
