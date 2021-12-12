use std::env;
use std::fs;

fn main() {
  let args: Vec<String> = env::args().collect();
  let filename = &args[1];
  let contents = fs::read_to_string(filename)
    .expect("Something went wrong reading the file");
  let measurements: Vec<i32> = contents.lines()
    .map(|x| x.parse::<i32>().unwrap()).collect();

  println!("Amount of all measurements: {}", measurements.len());
  println!("Amount of measurements larger than the previous: {}",
    count_larger_measurements(&measurements));
  println!("Amount of measurement sums larger than the previous: {}",
    count_larger_sums_of_measurements(&measurements));

  println!("Amount of measurements larger than the previous: {}",
    sliding_windows_solution(&measurements, 1));
  println!("Amount of measurement sums larger than the previous: {}",
    sliding_windows_solution(&measurements, 3));
}

// Part 1
fn count_larger_measurements(measurements: &Vec<i32>) -> i32 {
  let mut prev_measurement: i32 = measurements[0];
  
  let mut count: i32 = 0;
  for elem in measurements {
    let measurement: i32 = *elem;

    if measurement > prev_measurement {
      count += 1;
    }

    prev_measurement = measurement;
  }

  count
}

// Part 2
fn count_larger_sums_of_measurements(measurements: &Vec<i32>) -> i32 { 
  let mut prev_measurement_sum: i32 = measurements[0..3].iter().sum();
  
  let mut count: i32 = 0;
  for i in 0 ..= measurements.len()-3 {
    let measurement_sum: i32 = measurements[i..i+3].iter().sum();

    if measurement_sum > prev_measurement_sum {
      count += 1;
    }

    prev_measurement_sum = measurement_sum;
  }

  count
}

// More elegant solution for both parts
fn sliding_windows_solution(measurements: &Vec<i32>, window: usize) -> usize {
  measurements.iter()
    .zip(measurements[window..].iter())
    .filter(|(a, b)| a < b)
    .count()
}
