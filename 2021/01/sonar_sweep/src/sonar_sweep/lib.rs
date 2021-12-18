use std::fs;

/// Count the amount of increasing measurements
pub fn increasing_measurements(filename: &String, window: usize) -> usize {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let depths: Vec<i32> = contents
    .lines()
    .map(|x| x.parse::<i32>().unwrap())
    .collect();

  return depths
    .iter()
    .zip(depths[window..].iter())
    .filter(|(a, b)| a < b)
    .count();
}

// Test example inputs against the reference solution
#[cfg(test)]
mod sonar_sweep_tests {
  use super::increasing_measurements;
  const INPUT_FILENAME_1: &str = "input/example_input.txt";

  #[test]
  fn task_1() {
    assert_eq!(increasing_measurements(&INPUT_FILENAME_1.to_string(), 1), 7);
  }

  #[test]
  fn task_2() {
    assert_eq!(increasing_measurements(&INPUT_FILENAME_1.to_string(), 3), 5);
  }
}
