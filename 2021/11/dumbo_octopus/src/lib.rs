use std::fs;

/// Get the amount of flashes after a certain amount of steps.
pub fn flashes(filename: &String, steps: &usize) -> usize {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  // Get dimensions
  let m: usize = lines.len();
  let n: usize = lines[0].chars().count();

  // Get octopuses
  let mut octopuses: Vec<i32> = Vec::new();
  for line in lines.iter() {
    octopuses.extend(line.chars().map(|x| x.to_digit(10).unwrap() as i32));
  }

  // Simulate
  let mut n_flashes: usize = 0;
  for _ in 0..*steps {
    n_flashes += simulate_step(&m, &n, &mut octopuses);
  }

  return n_flashes;
}

/// Calculate the step when the flashes synchronize.
pub fn all_flash(filename: &String) -> usize {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  // Get dimensions
  let m: usize = lines.len();
  let n: usize = lines[0].chars().count();

  // Get octopuses
  let mut octopuses: Vec<i32> = Vec::new();
  for line in lines.iter() {
    octopuses.extend(line.chars().map(|x| x.to_digit(10).unwrap() as i32));
  }

  // Simulate until all flash
  let mut steps: usize = 1;
  while simulate_step(&m, &n, &mut octopuses) != octopuses.len() {
    steps += 1;
  }

  return steps;
}

/// Simulate one step.
fn simulate_step(m: &usize, n: &usize, octopuses: &mut Vec<i32>) -> usize {
  // Increment all
  octopuses.iter_mut().for_each(|x| *x += 1);

  let mut flashed: Vec<usize> = Vec::new();
  while get_flashes(m, n, octopuses, &mut flashed) {}

  return flashed.len();
}

/// Simulate flashes.
fn get_flashes(
  m: &usize,
  n: &usize,
  octopuses: &mut Vec<i32>,
  flashed: &mut Vec<usize>,
) -> bool {
  let mut has_flashed: bool = false;
  for i in 0..*m {
    for j in 0..*n {
      let idx = i * n + j;
      if !flashed.contains(&idx) && octopuses[idx] > 9 {
        octopuses[idx] = 0;
        flashed.push(idx);
        has_flashed = true;

        get_stencil(m, n, &idx)
          .iter()
          .filter(|k| !flashed.contains(&k))
          .for_each(|k| octopuses[*k] += 1);
      }
    }
  }

  return has_flashed;
}

/// Return a list of neighbouring octopus (9-stencil)
fn get_stencil(m: &usize, n: &usize, idx: &usize) -> Vec<usize> {
  let mut stencil: Vec<usize> = Vec::new();
  // left
  if (idx + 1) % n != 1 {
    stencil.push(idx - 1);
    if *idx >= *n {
      stencil.push(idx - n - 1);
    }
    if *idx < (m - 1) * n {
      stencil.push(idx + n - 1);
    }
  }
  // right
  if (idx + 1) % n != 0 {
    stencil.push(idx + 1);
    if *idx >= *n {
      stencil.push(idx - n + 1);
    }
    if *idx < (m - 1) * n {
      stencil.push(idx + n + 1);
    }
  }
  // up
  if *idx >= *n {
    stencil.push(idx - n);
  }
  // down
  if *idx < (m - 1) * n {
    stencil.push(idx + n);
  }
  return stencil;
}
