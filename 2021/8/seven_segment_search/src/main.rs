use std::fs;
use std::env;

mod seven_segment_display;
use seven_segment_display::SevenSegmentDisplay;
use seven_segment_display::create_seven_segment_display;

fn main() {
  let args: Vec<String> = env::args().collect();
  let filename: &String = &args[1];

  let n = get_amount_of_1478(&filename);
  println!("1. Amount of 1, 4, 7 and 8: {}", n);

  let s = sum_all_outputs(&filename);
  println!("1. Sum of all outputs: {}", s);
}

fn get_amount_of_1478(filename: &String) -> i32 {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  let mut amount: i32 = 0;

  for line in lines.iter() {
    let segments = line.split("|").nth(0).unwrap();
    let output = line.split("|").nth(1).unwrap();
    let mut display: SevenSegmentDisplay = create_seven_segment_display();
    display.init(segments);
    for num in output.split_whitespace() {
      if [1, 4, 7, 8].contains(&display.convert_number(num)) {
        amount += 1;
      }
    }
    
  }

  return amount;
}

fn sum_all_outputs(filename: &String) -> i32 {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  let mut sum: i32 = 0;

  for line in lines.iter() {
    let segments = line.split("|").nth(0).unwrap();
    let output = line.split("|").nth(1).unwrap();
    let mut display: SevenSegmentDisplay = create_seven_segment_display();
    display.init(segments);
    for (i, num) in output.split_whitespace().rev().enumerate() {
      sum += 10_i32.pow(i as u32) * display.convert_number(num);
    } 
  }

  return sum;
}



#[cfg(test)]
mod tests {
  use super::*;
  const INPUT_FILENAME: &str = "input/example_input.txt";

  #[test]
  fn test_1() {
    assert_eq!(get_amount_of_1478(&INPUT_FILENAME.to_string()), 26);
  }

  #[test]
  fn test_2() {
    assert_eq!(sum_all_outputs(&INPUT_FILENAME.to_string()), 61229);
  }
}

