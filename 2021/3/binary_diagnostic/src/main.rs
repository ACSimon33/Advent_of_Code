use std::fs;
use std::env;

fn main() {
  let args: Vec<String> = env::args().collect();
  let filename = &args[1];
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");

  const RADIX: u32 = 10;
  let binary_nums: Vec<Vec<i32>> = contents.lines()
    .map(|s| s.chars()
      .map(|c| c.to_digit(RADIX).unwrap() as i32).collect())
    .collect();

  let (gamma, epsilon) = gamma_and_epsilon(&binary_nums);
  println!("1. Gammma: {}", gamma);
  println!("1. Epsilon: {}", epsilon);
  println!("1. Power consumption: {}", gamma * epsilon);

  let (oxygen, co2) = oxygen_and_co2(&binary_nums);
  println!("1. Oxygen: {}", oxygen);
  println!("1. CO2: {}", co2);
  println!("1. Life supprt rating: {}", oxygen * co2);
}

fn binary_sum(binary_nums: &Vec<Vec<i32>>) -> Vec<i32> {
  let mut binary_sum: Vec<i32> = vec![0; binary_nums[0].len()];
  for num in binary_nums {
    for (i, b) in num.iter().enumerate() {
      binary_sum[i] += b;
    }
  }
  binary_sum
}

fn gamma_and_epsilon(binary_nums: &Vec<Vec<i32>>) -> (i32, i32) {
  let half: i32 = (binary_nums.len() / 2).try_into().unwrap();
  let base: i32 = 2;
  let bin_sum: Vec<i32> = binary_sum(binary_nums);

  let mut gamma: i32 = 0;
  let mut epsilon: i32 = 0;
  for (i, b) in bin_sum.iter().rev().enumerate() {
    if b >= &half {
      gamma += base.pow(i.try_into().unwrap());
    } else {
      epsilon += base.pow(i.try_into().unwrap());
    }
  }

  (gamma, epsilon)
}

fn bin_to_decimal(bin: &Vec<i32>) -> i32 {
  let base: i32 = 2;
  let mut dec: i32 = 0;
  for (i, b) in bin.iter().rev().enumerate() {
    dec += b * base.pow(i.try_into().unwrap());
  }
  dec
}

fn oxygen_and_co2(binary_nums: &Vec<Vec<i32>>) -> (i32, i32) {
  let mut oxygen = binary_nums.clone();
  let mut co2 = binary_nums.clone();
  let mut current_bit: usize = 0;

  while oxygen.len() > 1 {
    let half: f32 = (oxygen.len() as f32) / 2.0;
    let bin_sum: Vec<i32> = binary_sum(&oxygen);
    oxygen.retain(|x| {
      (x[current_bit] == 1 && (bin_sum[current_bit] as f32) >= half) ||
      (x[current_bit] == 0 && (bin_sum[current_bit] as f32) < half)
    });
    current_bit += 1;
  }

  current_bit = 0;
  while co2.len() > 1 {
    let half: f32 = (co2.len() as f32) / 2.0;
    let bin_sum: Vec<i32> = binary_sum(&co2);
    co2.retain(|x| {
      (x[current_bit] == 1 && (bin_sum[current_bit] as f32) < half) ||
      (x[current_bit] == 0 && (bin_sum[current_bit] as f32) >= half)
    });
    current_bit += 1;
  }

  (bin_to_decimal(&oxygen[0]), bin_to_decimal(&co2[0]))
}

