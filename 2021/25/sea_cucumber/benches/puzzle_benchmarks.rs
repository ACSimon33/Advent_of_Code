use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use sea_cucumber;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 25");
  group.sample_size(10);
  group.bench_function("Task 1 - Sea cucumber deadlock", |b| {
    b.iter(|| {
      sea_cucumber::steps_to_deadlock(black_box(&INPUT_FILENAME.to_string()))
    })
  });
  group.finish();
}

criterion_group!(benches, task_1);
criterion_main!(benches);
