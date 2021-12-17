use std::fs;

// First task
pub fn solution_1(filename: &String) -> i32 {
  let (x0, x1, y0, y1) = parse(filename);

  return 0;
}

fn parse(filename: &String) -> (i32, i32, i32, i32) {
  let mut contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  contents = contents.replace("target area: x=", "");

  let (x_str, y_str) = contents.split_once(", y=").unwrap();
  let (x0_str, x1_str) = x_str.split_once("..").unwrap();
  let (y0_str, y1_str) = y_str.split_once("..").unwrap();

  let x0: i32 = x0_str.parse().unwrap();
  let x1: i32 = x1_str.parse().unwrap();
  let y0: i32 = y0_str.parse().unwrap();
  let y1: i32 = y1_str.parse().unwrap();
  
  return (x0, x1, y0, y1);
}

fn 

// Test example inputs against the reference solution
#[cfg(test)]
mod rust_template_tests {
  use super::{solution_1};
  use pretty_assertions::assert_eq;
  const INPUT_FILENAME_1: &str = "input/example_input.txt";

  #[test]
  fn task_1() {
    assert_eq!(solution_1(&INPUT_FILENAME_1.to_string()), 0);
  }
}
