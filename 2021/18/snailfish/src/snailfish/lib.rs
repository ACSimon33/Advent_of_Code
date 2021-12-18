use std::cmp;
use std::fs;

mod pair;
use pair::Pair;

/// Sum up all snailfish numbers and return the magnitude.
pub fn sum_of_all_numbers(filename: &String) -> i32 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  // Parse snailfish numbers
  let nums: Vec<Pair> =
    lines.iter().map(|s| Pair::from(s.to_string())).collect();

  // Reduce and return magnitude
  let mut final_sum = nums[0].clone();
  for num in nums.iter().skip(1) {
    final_sum = &final_sum + num;
  }

  //println!("Final sum: {}", final_sum);
  return final_sum.magnitude();
}

/// Calculate the largest sum of two snailfish numbers.
pub fn largest_sum(filename: &String) -> i32 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  // Parse snailfish numbers
  let nums: Vec<Pair> =
    lines.iter().map(|s| Pair::from(s.to_string())).collect();

  // Reduce and return magnitude
  let mut magnitude: i32 = 0;
  for num1 in nums.iter() {
    for num2 in nums.iter().filter(|num2| &num1 != num2) {
      magnitude = cmp::max(magnitude, (num1 + num2).magnitude());
    }
  }

  return magnitude;
}

// Test example inputs against the reference solution
#[cfg(test)]
mod snailfish_tests {
  use super::{largest_sum, sum_of_all_numbers};
  use pretty_assertions::assert_eq;
  const INPUT_FILENAME_1: &str = "input/example_input_1.txt";
  const INPUT_FILENAME_2: &str = "input/example_input_2.txt";
  const INPUT_FILENAME_3: &str = "input/example_input_3.txt";
  const INPUT_FILENAME_4: &str = "input/example_input_4.txt";
  const INPUT_FILENAME_5: &str = "input/example_input_5.txt";
  const INPUT_FILENAME_6: &str = "input/example_input_6.txt";
  const INPUT_FILENAME_7: &str = "input/example_input_7.txt";

  #[test]
  fn task_1_1() {
    assert_eq!(sum_of_all_numbers(&INPUT_FILENAME_1.to_string()), 143);
  }

  #[test]
  fn task_1_2() {
    assert_eq!(sum_of_all_numbers(&INPUT_FILENAME_2.to_string()), 1384);
  }

  #[test]
  fn task_1_3() {
    assert_eq!(sum_of_all_numbers(&INPUT_FILENAME_3.to_string()), 445);
  }

  #[test]
  fn task_1_4() {
    assert_eq!(sum_of_all_numbers(&INPUT_FILENAME_4.to_string()), 791);
  }

  #[test]
  fn task_1_5() {
    assert_eq!(sum_of_all_numbers(&INPUT_FILENAME_5.to_string()), 1137);
  }

  #[test]
  fn task_1_6() {
    assert_eq!(sum_of_all_numbers(&INPUT_FILENAME_6.to_string()), 3488);
  }

  #[test]
  fn task_1_7() {
    assert_eq!(sum_of_all_numbers(&INPUT_FILENAME_7.to_string()), 4140);
  }

  #[test]
  fn task_2() {
    assert_eq!(largest_sum(&INPUT_FILENAME_7.to_string()), 3993);
  }
}
