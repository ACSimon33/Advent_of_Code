use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use hydrothermal_venture;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  c.bench_function(
    "Day 05, Task 1: Horizontal and vertical vents", 
    |b| b.iter(|| hydrothermal_venture::vent_point_cloud(
      black_box(&INPUT_FILENAME.to_string()), black_box(true)
  )));
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  c.bench_function(
    "Day 05, Task 2: All vents", 
    |b| b.iter(|| hydrothermal_venture::vent_point_cloud(
      black_box(&INPUT_FILENAME.to_string()), black_box(false)
  )));
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
