use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use seven_segment_search;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 08");
  group.bench_function(
    "Task 1 - Count 1, 4, 7 and 8", 
    |b| b.iter(|| seven_segment_search::get_amount_of_1478(
      black_box(&INPUT_FILENAME.to_string())
  )));
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 08");
  group.bench_function(
    "Task 2 - Decode and sum outputs", 
    |b| b.iter(|| seven_segment_search::sum_all_outputs(
      black_box(&INPUT_FILENAME.to_string())
  )));
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
