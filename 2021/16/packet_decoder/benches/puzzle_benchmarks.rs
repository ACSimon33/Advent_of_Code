use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use packet_decoder;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 16");
  group.bench_function("Task 1 - Sum of version numbers", |b| {
    b.iter(|| {
      packet_decoder::version_numbers(black_box(&INPUT_FILENAME.to_string()))
    })
  });
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 16");
  group.bench_function("Task 2 - Expression tree evaluation", |b| {
    b.iter(|| packet_decoder::evaluate(black_box(&INPUT_FILENAME.to_string())))
  });
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
