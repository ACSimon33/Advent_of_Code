use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use amphipod;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 23");
  group.bench_function("Task 1 - Rust Template", |b| {
    b.iter(|| amphipod::solution_1(black_box(&INPUT_FILENAME.to_string())))
  });
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 23");
  group.bench_function("Task 2 - Rust Template", |b| {
    b.iter(|| amphipod::solution_2(black_box(&INPUT_FILENAME.to_string())))
  });
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
