use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use syntax_scoring;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 10");
  group.bench_function(
    "Task 1 - Error score", 
    |b| b.iter(|| syntax_scoring::error_score(
      black_box(&INPUT_FILENAME.to_string())
  )));
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 10");
  group.bench_function(
    "Task 2 - Completion score", 
    |b| b.iter(|| syntax_scoring::completion_score(
      black_box(&INPUT_FILENAME.to_string())
  )));
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
