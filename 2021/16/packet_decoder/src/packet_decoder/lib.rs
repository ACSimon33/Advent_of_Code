use std::fs;

mod decoder;
use decoder::Decoder;

/// Part1: Calulate the sum of all version numbers
pub fn version_numbers(filename: &String) -> u64 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");

  let dec = Decoder::new(&contents);
  return dec.version_sum();
}

/// Part2: Evaluate the expression tree
pub fn evaluate(filename: &String) -> u64 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");

  let dec = Decoder::new(&contents);
  return dec.evaluate();
}

// Test example inputs against the reference solution
#[cfg(test)]
mod packet_decoder_tests {
  use super::{evaluate, version_numbers};
  use pretty_assertions::assert_eq;
  const INPUT_FILENAME_1_1: &str = "input/example_input_1_1.txt";
  const INPUT_FILENAME_1_2: &str = "input/example_input_1_2.txt";
  const INPUT_FILENAME_1_3: &str = "input/example_input_1_3.txt";
  const INPUT_FILENAME_1_4: &str = "input/example_input_1_4.txt";
  const INPUT_FILENAME_1_5: &str = "input/example_input_1_5.txt";
  const INPUT_FILENAME_2_1: &str = "input/example_input_2_1.txt";
  const INPUT_FILENAME_2_2: &str = "input/example_input_2_2.txt";
  const INPUT_FILENAME_2_3: &str = "input/example_input_2_3.txt";
  const INPUT_FILENAME_2_4: &str = "input/example_input_2_4.txt";
  const INPUT_FILENAME_2_5: &str = "input/example_input_2_5.txt";
  const INPUT_FILENAME_2_6: &str = "input/example_input_2_6.txt";
  const INPUT_FILENAME_2_7: &str = "input/example_input_2_7.txt";
  const INPUT_FILENAME_2_8: &str = "input/example_input_2_8.txt";

  #[test]
  fn task_1_1() {
    assert_eq!(version_numbers(&INPUT_FILENAME_1_1.to_string()), 6);
  }

  #[test]
  fn task_1_2() {
    assert_eq!(version_numbers(&INPUT_FILENAME_1_2.to_string()), 16);
  }

  #[test]
  fn task_1_3() {
    assert_eq!(version_numbers(&INPUT_FILENAME_1_3.to_string()), 12);
  }

  #[test]
  fn task_1_4() {
    assert_eq!(version_numbers(&INPUT_FILENAME_1_4.to_string()), 23);
  }

  #[test]
  fn task_1_5() {
    assert_eq!(version_numbers(&INPUT_FILENAME_1_5.to_string()), 31);
  }

  #[test]
  fn task_2_1() {
    assert_eq!(evaluate(&INPUT_FILENAME_2_1.to_string()), 3);
  }

  #[test]
  fn task_2_2() {
    assert_eq!(evaluate(&INPUT_FILENAME_2_2.to_string()), 54);
  }

  #[test]
  fn task_2_3() {
    assert_eq!(evaluate(&INPUT_FILENAME_2_3.to_string()), 7);
  }

  #[test]
  fn task_2_4() {
    assert_eq!(evaluate(&INPUT_FILENAME_2_4.to_string()), 9);
  }

  #[test]
  fn task_2_5() {
    assert_eq!(evaluate(&INPUT_FILENAME_2_5.to_string()), 1);
  }

  #[test]
  fn task_2_6() {
    assert_eq!(evaluate(&INPUT_FILENAME_2_6.to_string()), 0);
  }

  #[test]
  fn task_2_7() {
    assert_eq!(evaluate(&INPUT_FILENAME_2_7.to_string()), 0);
  }

  #[test]
  fn task_2_8() {
    assert_eq!(evaluate(&INPUT_FILENAME_2_8.to_string()), 1);
  }
}
