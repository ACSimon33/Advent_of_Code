use std::fs;

pub fn distance_depth(filename: &String) -> (i32, i32) {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");

  let directions: Vec<&str> = contents.lines()
    .map(|x| x.split(" ").nth(0).unwrap()).collect();
  let lengths: Vec<i32> = contents.lines()
    .map(|x| x.split(" ").nth(1).unwrap().parse().unwrap()).collect();

  (directional_sum(&directions, &lengths, "forward"),
   directional_sum(&directions, &lengths, "down") - 
   directional_sum(&directions, &lengths, "up"))
}

pub fn distance_depth_with_aim(filename: &String) -> (i32, i32) {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");

  let directions: Vec<&str> = contents.lines()
    .map(|x| x.split(" ").nth(0).unwrap()).collect();
  let lengths: Vec<i32> = contents.lines()
    .map(|x| x.split(" ").nth(1).unwrap().parse().unwrap()).collect();

  let mut aim: i32 = 0;
  let mut depth: i32 = 0;
  let mut distance: i32 = 0;

  for (&d, &c) in directions.iter().zip(lengths.iter()) {
    if d == "down" {
      aim += c;
    } else if d == "up" {
      aim -= c;
    } else if d == "forward" {
      distance += c;
      depth += aim * c;
    }
  }

  (distance, depth)
}

fn directional_sum(
  directions: &Vec<&str>, lengths: &Vec<i32>, key: &str) -> i32 {
  directions.iter().zip(lengths.iter())
    .filter(|(d, _c)| **d == key)
    .map(|(_d, c)| c).sum::<i32>()
}

#[cfg(test)]
mod dive_tests {
  use super::{distance_depth, distance_depth_with_aim};
  const INPUT_FILENAME: &str = "input/example_input.txt";

  #[test]
  fn task_1() {
    assert_eq!(distance_depth(&INPUT_FILENAME.to_string()), (15, 10));
  }

  #[test]
  fn task_2() {
    assert_eq!(distance_depth_with_aim(&INPUT_FILENAME.to_string()), (15, 60));
  }
}
