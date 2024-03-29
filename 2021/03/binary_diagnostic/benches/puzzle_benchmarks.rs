use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use binary_diagnostic;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 03");
  group.bench_function("Task 1 - Power consumption", |b| {
    b.iter(|| {
      binary_diagnostic::gamma_and_epsilon(black_box(
        &INPUT_FILENAME.to_string(),
      ))
    })
  });
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 03");
  group.bench_function("Task 2 - Life support rating", |b| {
    b.iter(|| {
      binary_diagnostic::oxygen_and_co2(black_box(&INPUT_FILENAME.to_string()))
    })
  });
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
