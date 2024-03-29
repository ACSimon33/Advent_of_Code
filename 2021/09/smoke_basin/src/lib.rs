use std::fs;

/// Calculate the risk level.
pub fn risk_level(filename: &String) -> Vec<i32> {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  // Get dimensions
  let m: usize = lines.len();
  let n: usize = lines[0].chars().count();

  // Get height map
  let mut heights: Vec<i32> = Vec::new();
  for line in lines.iter() {
    heights.extend(line.chars().map(|x| x.to_digit(10).unwrap() as i32));
  }

  // Get low points
  let low_p: Vec<usize> = low_points(&m, &n, &heights);

  // Calculate risk levels
  let mut risk_level: Vec<i32> = vec![0; low_p.len()];
  for (i, p) in low_p.iter().enumerate() {
    risk_level[i] = heights[*p] + 1;
  }

  return risk_level;
}

/// Return the sizes of the largest basins.
pub fn basins(filename: &String, amount: usize) -> Vec<usize> {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  // Get dimensions
  let m: usize = lines.len();
  let n: usize = lines[0].chars().count();

  // Get height map
  let mut heights: Vec<i32> = Vec::new();
  for line in lines.iter() {
    heights.extend(line.chars().map(|x| x.to_digit(10).unwrap() as i32));
  }

  // Get low points
  let low_p: Vec<usize> = low_points(&m, &n, &heights);

  return get_basins(&m, &n, &heights, &low_p, amount);
}

/// Find the low points (minima).
fn low_points(m: &usize, n: &usize, heights: &Vec<i32>) -> Vec<usize> {
  let mut low_p: Vec<usize> = Vec::new();
  for i in 0..*m {
    for j in 0..*n {
      let idx = i * n + j;
      if get_stencil(m, n, &idx)
        .iter()
        .all(|&i| heights[idx] < heights[i])
      {
        low_p.push(idx);
      }
    }
  }

  return low_p;
}

/// Get the n largest basins.
fn get_basins(
  m: &usize,
  n: &usize,
  heights: &Vec<i32>,
  low_p: &Vec<usize>,
  b: usize,
) -> Vec<usize> {
  let mut basins: Vec<usize> = vec![0; b];
  for p in low_p.iter() {
    let mut basin: Vec<usize> = Vec::new();
    get_basin_cells(m, n, heights, p, &mut basin);

    let min_basin = basins.iter_mut().min().unwrap();
    if min_basin < &mut basin.len() {
      *min_basin = basin.len();
    }
  }

  return basins;
}

/// Get all cells of a basin.
fn get_basin_cells(
  m: &usize,
  n: &usize,
  heights: &Vec<i32>,
  idx: &usize,
  basin: &mut Vec<usize>,
) {
  if basin.contains(idx) {
    return;
  } else {
    basin.push(*idx);
  }

  for i in get_stencil(m, n, &idx)
    .iter()
    .filter(|&i| heights[*idx] < heights[*i] && heights[*i] < 9)
  {
    get_basin_cells(m, n, heights, i, basin);
  }
}

/// Return a list of neighbouring points (5 stencil).
fn get_stencil(m: &usize, n: &usize, idx: &usize) -> Vec<usize> {
  let mut stencil: Vec<usize> = Vec::new();
  if (idx + 1) % n != 1 {
    stencil.push(idx - 1);
  }
  if (idx + 1) % n != 0 {
    stencil.push(idx + 1);
  }
  if *idx >= *n {
    stencil.push(idx - n);
  }
  if *idx < (m - 1) * n {
    stencil.push(idx + n);
  }
  return stencil;
}
