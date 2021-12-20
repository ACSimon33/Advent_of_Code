use std::fs;

/// Count the amount of lit pixels after a certain amount of steps
pub fn count_lit_pixels(filename: &String, steps: &usize) -> usize {
  let (mut m, mut n, key, mut image) = parse(filename);
  let mut background = '0';

  for _ in 0..*steps {
    //_print_image(&m, &n, &image);
    enhance_image(&mut m, &mut n, &key, &mut image, &mut background);
  }
  //_print_image(&m, &n, &image);

  return image.iter().filter(|&c| *c == '1').count();
}

/// Parse the input.
fn parse(filename: &String) -> (usize, usize, Vec<char>, Vec<char>) {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  // The algorithm
  let key = lines[0]
    .chars()
    .map(|c| match c {
      '.' => '0',
      '#' => '1',
      _ => c,
    })
    .collect();

  // Dimensions
  let m = lines.len() - 2;
  let n = lines[3].len();

  let image = lines
    .iter()
    .skip(2)
    .flat_map(|line| {
      line
        .chars()
        .map(|c| match c {
          '.' => '0',
          '#' => '1',
          _ => c,
        })
        .collect::<Vec<char>>()
    })
    .collect();

  return (m, n, key, image);
}

/// Enhance the image according to the key.
fn enhance_image(
  m: &mut usize,
  n: &mut usize,
  key: &Vec<char>,
  image: &mut Vec<char>,
  background: &mut char,
) {
  let mut new_image: Vec<char> = vec!['0'; (*m + 2) * (*n + 2)];

  for i in -1..(*m as i32) + 1 {
    for j in -1..(*n as i32) + 1 {
      let mut bin_str = String::new();
      for k in get_stencil(*m as i32, *n as i32, i, j).iter() {
        if *k == usize::MAX {
          bin_str.push(*background);
        } else {
          bin_str.push(image[*k]);
        }
      }
      //_print_image(&3, &3, &bin_str.chars().collect());
      new_image[index((*n + 2) as i32, i + 1, j + 1)] =
        key[usize::from_str_radix(&bin_str, 2).unwrap()]
    }
  }

  // Process background (this part was sneaky). Since the value in the key
  // at position 0 was 1 and the value at position 511 was 0 the infinite
  // backgroud changes the value in each iteration.
  let background_idx = vec![*background; 9].iter().collect::<String>();
  *background = key[usize::from_str_radix(background_idx.as_str(), 2).unwrap()];

  *m += 2;
  *n += 2;
  *image = new_image;
}

/// Return a list of the all neighbouring cells including the middle cell.
fn get_stencil(m: i32, n: i32, i: i32, j: i32) -> Vec<usize> {
  let mut stencil: Vec<usize> = vec![usize::MAX; 9];
  // middle
  if i >= 0 && i <= m - 1 && j >= 0 && j <= n - 1 {
    stencil[4] = index(n, i, j);
  }
  // left
  if j >= 1 {
    if i >= 0 && i <= m - 1 {
      stencil[3] = index(n, i, j - 1);
    }
    if i >= 1 {
      stencil[0] = index(n, i - 1, j - 1);
    }
    if i <= m - 2 {
      stencil[6] = index(n, i + 1, j - 1);
    }
  }
  // right
  if j <= n - 2 {
    if i >= 0 && i <= m - 1 {
      stencil[5] = index(n, i, j + 1);
    }
    if i >= 1 {
      stencil[2] = index(n, i - 1, j + 1);
    }
    if i <= m - 2 {
      stencil[8] = index(n, i + 1, j + 1);
    }
  }
  // up
  if i >= 1 {
    if j >= 0 && j <= n - 1 {
      stencil[1] = index(n, i - 1, j);
    }
  }
  // down
  if i <= m - 2 {
    if j >= 0 && j <= n - 1 {
      stencil[7] = index(n, i + 1, j);
    }
  }

  return stencil;
}

/// Get the flattened index.
fn index(n: i32, i: i32, j: i32) -> usize {
  (i * n + j) as usize
}

/// Print the image (for debug purposes).
fn _print_image(m: &usize, n: &usize, image: &Vec<char>) {
  for i in 0..*m {
    for j in 0..*n {
      let idx = index(*n as i32, i as i32, j as i32);
      if image[idx] == '0' {
        print!(".");
      } else {
        print!("#");
      }
    }
    println!();
  }
  println!();
}
