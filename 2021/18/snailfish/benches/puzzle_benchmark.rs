use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use snailfish;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 18");
  group.bench_function(
    "Task 1 - Sum of all Snailfish numbers", 
    |b| b.iter(|| snailfish::sum_of_all_numbers(
      black_box(&INPUT_FILENAME.to_string())
  )));
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 18");
  group.bench_function(
    "Task 2 - Largest sum between two Snailfish numbers", 
    |b| b.iter(|| snailfish::largest_sum(
      black_box(&INPUT_FILENAME.to_string())
  )));
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
