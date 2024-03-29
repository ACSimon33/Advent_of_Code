use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use dumbo_octopus;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 11");
  group.bench_function("Task 1 - Amount of flashes after 100 steps", |b| {
    b.iter(|| {
      dumbo_octopus::flashes(
        black_box(&INPUT_FILENAME.to_string()),
        black_box(&100),
      )
    })
  });
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 11");
  group.bench_function("Task 2 - Amount of steps until synchronization", |b| {
    b.iter(|| dumbo_octopus::all_flash(black_box(&INPUT_FILENAME.to_string())))
  });
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
