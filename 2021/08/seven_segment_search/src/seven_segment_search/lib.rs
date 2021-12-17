use std::fs;

mod seven_segment_display;
use seven_segment_display::SevenSegmentDisplay;

/// Calculate the occurances of 1, 4, 7 and 8.
pub fn get_amount_of_1478(filename: &String) -> i32 {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  let mut amount: i32 = 0;

  for line in lines.iter() {
    let segments = line.split("|").nth(0).unwrap();
    let output = line.split("|").nth(1).unwrap();
    let mut display: SevenSegmentDisplay = SevenSegmentDisplay::new();
    display.init(segments);
    for num in output.split_whitespace() {
      if [1, 4, 7, 8].contains(&display.convert_number(num)) {
        amount += 1;
      }
    }
  }

  return amount;
}

/// Calculate the sum of all output values.
pub fn sum_all_outputs(filename: &String) -> i32 {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  let mut sum: i32 = 0;

  for line in lines.iter() {
    let segments = line.split("|").nth(0).unwrap();
    let output = line.split("|").nth(1).unwrap();
    let mut display: SevenSegmentDisplay = SevenSegmentDisplay::new();
    display.init(segments);
    for (i, num) in output.split_whitespace().rev().enumerate() {
      sum += 10_i32.pow(i as u32) * display.convert_number(num);
    } 
  }

  return sum;
}

// Test example inputs against the reference solution
#[cfg(test)]
mod seven_segment_search_tests {
  use super::{get_amount_of_1478, sum_all_outputs};
  const INPUT_FILENAME: &str = "input/example_input.txt";

  #[test]
  fn task_1() {
    assert_eq!(get_amount_of_1478(&INPUT_FILENAME.to_string()), 26);
  }

  #[test]
  fn task_2() {
    assert_eq!(sum_all_outputs(&INPUT_FILENAME.to_string()), 61229);
  }
}

