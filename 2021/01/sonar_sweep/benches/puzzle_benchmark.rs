use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use sonar_sweep;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 01");
  group.bench_function(
    "Task 1 - Amount of increasing measurements", 
    |b| b.iter(|| sonar_sweep::increasing_measurements(
      black_box(&INPUT_FILENAME.to_string()), black_box(1)
  )));
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 01");
  group.bench_function(
    "Task 2 - Amount of increasing measurement sums", 
    |b| b.iter(|| sonar_sweep::increasing_measurements(
      black_box(&INPUT_FILENAME.to_string()), black_box(3)
  )));
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
