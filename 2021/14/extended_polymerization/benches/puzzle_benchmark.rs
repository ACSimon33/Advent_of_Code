use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use extended_polymerization;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  c.bench_function(
    "Day 14, Task 1: Element counts after 10 steps", 
    |b| b.iter(|| extended_polymerization::get_elements(
      black_box(&INPUT_FILENAME.to_string()), black_box(&10)
  )));
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  c.bench_function(
    "Day 14, Task 2: Element counts after 40 steps", 
    |b| b.iter(|| extended_polymerization::get_elements(
      black_box(&INPUT_FILENAME.to_string()), black_box(&40)
  )));
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
