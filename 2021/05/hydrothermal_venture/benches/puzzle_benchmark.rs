use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use hydrothermal_venture;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 05");
  group.bench_function("Task 1 - Horizontal and vertical vents", |b| {
    b.iter(|| {
      hydrothermal_venture::vent_point_cloud(
        black_box(&INPUT_FILENAME.to_string()),
        black_box(true),
      )
    })
  });
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 05");
  group.bench_function("Task 2 - All vents", |b| {
    b.iter(|| {
      hydrothermal_venture::vent_point_cloud(
        black_box(&INPUT_FILENAME.to_string()),
        black_box(false),
      )
    })
  });
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
