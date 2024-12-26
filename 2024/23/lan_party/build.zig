const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const lan_party = b.addModule("lan_party", .{
        .root_source_file = b.path("src/lan_party.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const lan_party_exe = b.addExecutable(.{
        .name = "lan_party",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    lan_party_exe.root_module.addImport("yazap", yazap.module("yazap"));
    lan_party_exe.root_module.addImport("lan_party", lan_party);
    b.installArtifact(lan_party_exe);

    const run_cmd = b.addRunArtifact(lan_party_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run LAN Party (day 23) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const lan_party_tests = b.addTest(.{
        .name = "lan_party_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    lan_party_tests.root_module.addImport("lan_party", lan_party);
    lan_party_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(lan_party_tests);

    const test_step = b.step("test", "Run LAN Party (day 23) tests");
    test_step.dependOn(&b.addRunArtifact(lan_party_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const lan_party_benchmarks = b.addExecutable(.{
        .name = "lan_party_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    lan_party_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    lan_party_benchmarks.root_module.addImport("lan_party", lan_party);
    lan_party_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(lan_party_benchmarks);

    const benchmark_step = b.step("benchmark", "Run LAN Party (day 23) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(lan_party_benchmarks).step);
}
