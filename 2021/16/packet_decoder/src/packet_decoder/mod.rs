use std::fs;

// First task
pub fn version_numbers(filename: &String) -> i32 {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let _lines: Vec<&str> = contents.lines().collect();

  return 0;
}

// Test example inputs against the reference solution
#[cfg(test)]
mod tests {
  use super::{version_numbers};
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
    assert_eq!(version_numbers(&INPUT_FILENAME_1.to_string()), 6);
  }

  #[test]
  fn task_1_2() {
    assert_eq!(version_numbers(&INPUT_FILENAME_2.to_string()), 1);
  }

  #[test]
  fn task_1_3() {
    assert_eq!(version_numbers(&INPUT_FILENAME_3.to_string()), 7);
  }

  #[test]
  fn task_1_4() {
    assert_eq!(version_numbers(&INPUT_FILENAME_4.to_string()), 16);
  }

  #[test]
  fn task_1_5() {
    assert_eq!(version_numbers(&INPUT_FILENAME_5.to_string()), 12);
  }

  #[test]
  fn task_1_6() {
    assert_eq!(version_numbers(&INPUT_FILENAME_6.to_string()), 23);
  }

  #[test]
  fn task_1_7() {
    assert_eq!(version_numbers(&INPUT_FILENAME_7.to_string()), 31);
  }
}
