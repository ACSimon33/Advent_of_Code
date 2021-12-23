use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_input.txt";

// Import puzzle solutions module
use reactor_reboot;

/// Benchmark of part 1
fn task_1(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 22");
  group.sample_size(10);
  group.bench_function("Task 1 - Lit cubes in the initialization area", |b| {
    b.iter(|| {
      reactor_reboot::count_cubes(
        black_box(&INPUT_FILENAME.to_string()),
        black_box(50),
      )
    })
  });
  group.finish();
}

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 22");
  group.sample_size(10);
  group.bench_function("Task 2 - Lit cubes in the whole domain", |b| {
    b.iter(|| {
      reactor_reboot::count_cubes(
        black_box(&INPUT_FILENAME.to_string()),
        black_box(0),
      )
    })
  });
  group.finish();
}

criterion_group!(benches, task_1, task_2);
criterion_main!(benches);
