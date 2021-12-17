use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use lanternfish;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  c.bench_function(
    "Day 06, Task 1: Lanternfish population after 80 days", 
    |b| b.iter(|| lanternfish::lanternfish(
      black_box(&INPUT_FILENAME.to_string()), black_box(&80)
  )));
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  c.bench_function(
    "Day 06, Task 2: Lanternfish population after 256 days", 
    |b| b.iter(|| lanternfish::lanternfish(
      black_box(&INPUT_FILENAME.to_string()), black_box(&256)
  )));
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
