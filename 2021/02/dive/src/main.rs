use std::fs;
use std::env;

fn main() {
  let args: Vec<String> = env::args().collect();
  let filename = &args[1];
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");

  let directions: Vec<&str> = contents.lines()
    .map(|x| x.split(" ").nth(0).unwrap()).collect();

  let lengths: Vec<i32> = contents.lines()
    .map(|x| x.split(" ").nth(1).unwrap().parse().unwrap()).collect();

  let distance_1 = directional_sum(&directions, &lengths, "forward");
  let depth_1 = directional_sum(&directions, &lengths, "down")
    - directional_sum(&directions, &lengths, "up");
  println!("1. Final location forward: {}", distance_1);
  println!("1. Final depth: {}", depth_1);
  println!("1. Product: {}", distance_1 * depth_1);

  let (distance_2, depth_2) = distance_depth_with_aim(&directions, &lengths);
  println!("2. Final location forward: {}", distance_2);
  println!("2. Final depth: {}", depth_2);
  println!("2. Product: {}", distance_2 * depth_2);
}

fn directional_sum(
  directions: &Vec<&str>, lengths: &Vec<i32>, key: &str) -> i32 {
  directions.iter().zip(lengths.iter())
    .filter(|(d, _c)| **d == key)
    .map(|(_d, c)| c).sum::<i32>()
}

fn distance_depth_with_aim(
  directions: &Vec<&str>, lengths: &Vec<i32>) -> (i32, i32) {

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

