use criterion::{black_box, criterion_group, criterion_main, Criterion};

// Puzzle input
const INPUT_FILENAME: &str = "input/puzzle_program.txt";

// Import puzzle solutions module
use arithmetic_logic_unit;

/// Benchmark of part 1
// fn task_1(c: &mut Criterion) {
//   let mut group = c.benchmark_group("Day 24");
//   group.bench_function("Task 1 - Maximum model number", |b| {
//     b.iter(|| {
//       arithmetic_logic_unit::maximum_model_number(black_box(
//         &INPUT_FILENAME.to_string(),
//       ))
//     })
//   });
//   group.finish();
// }

/// Benchmark of part 2
fn task_2(c: &mut Criterion) {
  let mut group = c.benchmark_group("Day 24");
  group.bench_function("Task 2 - Minimum Model number", |b| {
    b.iter(|| {
      arithmetic_logic_unit::minimum_model_number(black_box(
        &INPUT_FILENAME.to_string(),
      ))
    })
  });
  group.finish();
}

criterion_group!(benches, task_2);
criterion_main!(benches);
