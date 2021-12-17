use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use rust_template;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  c.bench_function(
    "Day 0, Task 1: Rust Template", 
    |b| b.iter(|| rust_template::solution_1(
      black_box(&INPUT_FILENAME.to_string())
  )));
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  c.bench_function(
    "Day 0, Task 2: Rust Template", 
    |b| b.iter(|| rust_template::solution_2(
      black_box(&INPUT_FILENAME.to_string())
  )));
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
