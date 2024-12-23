const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const monkey_market = b.addModule("monkey_market", .{
        .root_source_file = b.path("src/monkey_market.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const monkey_market_exe = b.addExecutable(.{
        .name = "monkey_market",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    monkey_market_exe.root_module.addImport("yazap", yazap.module("yazap"));
    monkey_market_exe.root_module.addImport("monkey_market", monkey_market);
    b.installArtifact(monkey_market_exe);

    const run_cmd = b.addRunArtifact(monkey_market_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Monkey Market (day 22) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const monkey_market_tests = b.addTest(.{
        .name = "monkey_market_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    monkey_market_tests.root_module.addImport("monkey_market", monkey_market);
    inline for (1..4) |i| {
        const num_str = std.fmt.comptimePrint("{!}", .{i});
        monkey_market_tests.root_module.addAnonymousImport(
            "example_input_" ++ num_str,
            .{
                .root_source_file = b.path("input/example_input_" ++ num_str ++ ".txt"),
            },
        );
    }
    b.installArtifact(monkey_market_tests);

    const test_step = b.step("test", "Run Monkey Market (day 22) tests");
    test_step.dependOn(&b.addRunArtifact(monkey_market_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const monkey_market_benchmarks = b.addExecutable(.{
        .name = "monkey_market_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    monkey_market_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    monkey_market_benchmarks.root_module.addImport("monkey_market", monkey_market);
    monkey_market_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(monkey_market_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Monkey Market (day 22) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(monkey_market_benchmarks).step);
}
