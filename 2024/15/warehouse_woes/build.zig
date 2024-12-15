const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const warehouse_woes = b.addModule("warehouse_woes", .{
        .root_source_file = b.path("src/warehouse_woes.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const warehouse_woes_exe = b.addExecutable(.{
        .name = "warehouse_woes",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    warehouse_woes_exe.root_module.addImport("yazap", yazap.module("yazap"));
    warehouse_woes_exe.root_module.addImport("warehouse_woes", warehouse_woes);
    b.installArtifact(warehouse_woes_exe);

    const run_cmd = b.addRunArtifact(warehouse_woes_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Warehouse Woes (day 15) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const warehouse_woes_tests = b.addTest(.{
        .name = "warehouse_woes_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    warehouse_woes_tests.root_module.addImport("warehouse_woes", warehouse_woes);
    inline for (1..3) |i| {
        const num_str = std.fmt.comptimePrint("{!}", .{i});
        warehouse_woes_tests.root_module.addAnonymousImport(
            "example_input_" ++ num_str,
            .{
                .root_source_file = b.path("input/example_input_" ++ num_str ++ ".txt"),
            },
        );
    }
    b.installArtifact(warehouse_woes_tests);

    const test_step = b.step("test", "Run Warehouse Woes (day 15) tests");
    test_step.dependOn(&b.addRunArtifact(warehouse_woes_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const warehouse_woes_benchmarks = b.addExecutable(.{
        .name = "warehouse_woes_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    warehouse_woes_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    warehouse_woes_benchmarks.root_module.addImport("warehouse_woes", warehouse_woes);
    warehouse_woes_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(warehouse_woes_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Warehouse Woes (day 15) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(warehouse_woes_benchmarks).step);
}
