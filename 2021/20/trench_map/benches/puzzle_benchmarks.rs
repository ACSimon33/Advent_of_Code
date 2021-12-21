use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use trench_map;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 20");
  group.bench_function("Task 1 - Lit pixels after 2 enhancements", |b| {
    b.iter(|| {
      trench_map::count_lit_pixels(
        black_box(&INPUT_FILENAME.to_string()),
        black_box(&2),
      )
    })
  });
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 20");
  group.bench_function("Task 2 - Lit pixels after 50 enhancements", |b| {
    b.iter(|| {
      trench_map::count_lit_pixels(
        black_box(&INPUT_FILENAME.to_string()),
        black_box(&50),
      )
    })
  });
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
