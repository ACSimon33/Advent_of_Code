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
