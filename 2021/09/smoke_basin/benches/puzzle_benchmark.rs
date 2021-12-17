use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use smoke_basin;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 09");
  group.bench_function(
    "Task 1 - Calculate risk level", 
    |b| b.iter(|| smoke_basin::risk_level(
      black_box(&INPUT_FILENAME.to_string())
  )));
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 09");
  group.bench_function(
    "Task 2 - Caluclate size of the 3 largest basins", 
    |b| b.iter(|| smoke_basin::basins(
      black_box(&INPUT_FILENAME.to_string()), black_box(3)
  )));
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
