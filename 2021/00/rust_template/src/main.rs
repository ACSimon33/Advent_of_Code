use std::fs;
use std::env;

// Main entry point
fn main() {
  let args: Vec<String> = env::args().collect();
  if args.len() < 2 {
    panic!("Error: Input file missing.");
  }
  let filename: &String = &args[1];

  let val_1 = task_1(&filename);
  println!("1. Solution: {}", val_1);

  let val_2 = task_2(&filename);
  println!("2. Solution: {}", val_2);
}

// First task
fn task_1(filename: &String) -> i32 {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let _lines: Vec<&str> = contents.lines().collect();

  return 0;
}

// Second task
fn task_2(filename: &String) -> i32 {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let _lines: Vec<&str> = contents.lines().collect();

  return 1;
}

// Test example inputs against the reference solution
#[cfg(test)]
mod tests {
  use super::*;
  const INPUT_FILENAME_1: &str = "input/example_input.txt";

  #[test]
  fn test_1() {
    assert_eq!(task_1(&INPUT_FILENAME_1.to_string()), 0);
  }

  #[test]
  fn test_2() {
    assert_eq!(task_2(&INPUT_FILENAME_1.to_string()), 1);
  }
}
