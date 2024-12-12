const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const hoof_it = b.addModule("hoof_it", .{
        .root_source_file = b.path("src/hoof_it.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const hoof_it_exe = b.addExecutable(.{
        .name = "hoof_it",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    hoof_it_exe.root_module.addImport("yazap", yazap.module("yazap"));
    hoof_it_exe.root_module.addImport("hoof_it", hoof_it);
    b.installArtifact(hoof_it_exe);

    const run_cmd = b.addRunArtifact(hoof_it_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Hoof It (day 10) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const hoof_it_tests = b.addTest(.{
        .name = "hoof_it_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    hoof_it_tests.root_module.addImport("hoof_it", hoof_it);
    inline for (1..8) |i| {
        const num_str = std.fmt.comptimePrint("{!}", .{i});
        hoof_it_tests.root_module.addAnonymousImport(
            "example_input_" ++ num_str,
            .{
                .root_source_file = b.path("input/example_input_" ++ num_str ++ ".txt"),
            },
        );
    }
    b.installArtifact(hoof_it_tests);

    const test_step = b.step("test", "Run Hoof It (day 10) tests");
    test_step.dependOn(&b.addRunArtifact(hoof_it_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const hoof_it_benchmarks = b.addExecutable(.{
        .name = "hoof_it_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    hoof_it_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    hoof_it_benchmarks.root_module.addImport("hoof_it", hoof_it);
    hoof_it_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(hoof_it_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Hoof It (day 10) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(hoof_it_benchmarks).step);
}
