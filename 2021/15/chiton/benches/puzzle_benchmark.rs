use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use chiton;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  c.bench_function(
    "Lowest Total Risk", 
    |b| b.iter(|| chiton::lowest_total_risk(
      black_box(&INPUT_FILENAME.to_string())
  )));
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  c.bench_function(
    "Lowest Total Risk (full map)", 
    |b| b.iter(|| chiton::lowest_total_risk_full(
      black_box(&INPUT_FILENAME.to_string())
  )));
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
