use std::fs;

// First task
pub fn solution_1(filename: &String) -> i32 {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let _lines: Vec<&str> = contents.lines().collect();

  return 0;
}

// Second task
pub fn solution_2(filename: &String) -> i32 {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let _lines: Vec<&str> = contents.lines().collect();

  return 1;
}

// Test example inputs against the reference solution
#[cfg(test)]
mod rust_template_tests {
  use super::{solution_1, solution_2};
  use pretty_assertions::assert_eq;
  const INPUT_FILENAME_1: &str = "input/example_input.txt";

  #[test]
  fn task_1() {
    assert_eq!(solution_1(&INPUT_FILENAME_1.to_string()), 0);
  }

  #[test]
  fn task_2() {
    assert_eq!(solution_2(&INPUT_FILENAME_1.to_string()), 1);
  }
}
