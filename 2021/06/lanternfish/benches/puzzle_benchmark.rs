use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use lanternfish;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 06");
  group.bench_function("Task 1 - Lanternfish population after 80 days", |b| {
    b.iter(|| {
      lanternfish::lanternfish(
        black_box(&INPUT_FILENAME.to_string()),
        black_box(&80),
      )
    })
  });
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 06");
  group.bench_function("Task 2 - Lanternfish population after 256 days", |b| {
    b.iter(|| {
      lanternfish::lanternfish(
        black_box(&INPUT_FILENAME.to_string()),
        black_box(&256),
      )
    })
  });
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
