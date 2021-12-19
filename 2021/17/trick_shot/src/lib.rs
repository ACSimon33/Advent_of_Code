use std::fs;

/// Calculate the heighest possible shot.
pub fn heighest_shot(filename: &String) -> i32 {
  let (_, _, y0, y1) = parse(filename);
  let (y_speeds, _) = get_possible_y_speeds(&y0, &y1);

  return gauss(*y_speeds.iter().max().unwrap());
}

/// Calculate the amount of distinct velocity values.
pub fn distinct_velocities(filename: &String) -> usize {
  let (x0, x1, y0, y1) = parse(filename);
  let (x_speeds, x_steps) = get_possible_x_speeds(&x0, &x1);
  let (y_speeds, y_steps) = get_possible_y_speeds(&y0, &y1);

  let mut velocities: Vec<(i32, i32)> = Vec::new();
  for (x_speed, x_step) in x_speeds.iter().zip(x_steps.iter()) {
    for (y_speed, y_step) in y_speeds.iter().zip(y_steps.iter()) {
      if x_step == y_step || (x_speed == x_step && x_step <= y_step) {
        if !velocities.contains(&(*x_speed, *y_speed)) {
          velocities.push((*x_speed, *y_speed));
          // println!("{} {}", x_speed, y_speed);
        }
      }
    }
  }

  return velocities.len();
}

/// Parse the input.
fn parse(filename: &String) -> (i32, i32, i32, i32) {
  let mut contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  contents = contents.replace("target area: x=", "");

  let (x_str, y_str) = contents.split_once(", y=").unwrap();
  let (x0_str, x1_str) = x_str.split_once("..").unwrap();
  let (y0_str, y1_str) = y_str.split_once("..").unwrap();

  let x0: i32 = x0_str.parse().unwrap();
  let x1: i32 = x1_str.parse().unwrap();
  let y0: i32 = y0_str.parse().unwrap();
  let y1: i32 = y1_str.parse().unwrap();

  return (x0, x1, y0, y1);
}

/// Calculate all possible speeds in x direction.
fn get_possible_x_speeds(x0: &i32, x1: &i32) -> (Vec<i32>, Vec<i32>) {
  let mut x_speeds: Vec<i32> = Vec::new();
  let mut x_steps: Vec<i32> = Vec::new();
  for speed in (1..).filter(|s| gauss(*s) >= *x0) {
    if speed > *x1 {
      break;
    }

    for steps in 1..speed + 1 {
      let distance = gauss(speed) - gauss(speed - steps);
      if distance >= *x0 && distance <= *x1 {
        x_speeds.push(speed);
        x_steps.push(steps);
      }
    }
  }

  return (x_speeds, x_steps);
}

/// Calculate all possible speeds in y direction.
fn get_possible_y_speeds(y0: &i32, y1: &i32) -> (Vec<i32>, Vec<i32>) {
  let mut y_speeds: Vec<i32> = Vec::new();
  let mut y_steps: Vec<i32> = Vec::new();
  for speed in *y0.. {
    if speed > gauss(y0.abs()) {
      break;
    }

    for steps in 1.. {
      let height = gauss(speed) - gauss(speed - steps);
      if height >= *y0 && height <= *y1 {
        y_speeds.push(speed);
        y_steps.push(steps);
      } else if height < *y0 {
        break;
      }
    }
  }

  return (y_speeds, y_steps);
}

/// Gaussian sum.
fn gauss(x: i32) -> i32 {
  x * (x + 1) / 2
}
