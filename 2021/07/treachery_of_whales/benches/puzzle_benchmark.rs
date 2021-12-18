use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use treachery_of_whales;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 07");
  group.bench_function(
    "Task 1 - Crab formation with constant fuel consumption",
    |b| {
      b.iter(|| {
        treachery_of_whales::crab_formation_1(black_box(
          &INPUT_FILENAME.to_string(),
        ))
      })
    },
  );
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 07");
  group.bench_function(
    "Task 2 - Crab formation with linear fuel consumption",
    |b| {
      b.iter(|| {
        treachery_of_whales::crab_formation_2(black_box(
          &INPUT_FILENAME.to_string(),
        ))
      })
    },
  );
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
