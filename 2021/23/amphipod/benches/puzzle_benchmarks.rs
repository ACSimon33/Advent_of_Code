use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME_1: &str = "input/puzzle_input_1.txt";
const INPUT_FILENAME_2: &str = "input/puzzle_input_2.txt";

// Import puzzle solutions module
use amphipod;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 23");
  group.bench_function("Task 1 - Least amount of energy (small rooms)", |b| {
    b.iter(|| {
      amphipod::least_amount_of_energy(black_box(&INPUT_FILENAME_1.to_string()))
    })
  });
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 23");
  group.bench_function("Task 2 - Least amount of energy (large rooms)", |b| {
    b.iter(|| {
      amphipod::least_amount_of_energy(black_box(&INPUT_FILENAME_2.to_string()))
    })
  });
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
