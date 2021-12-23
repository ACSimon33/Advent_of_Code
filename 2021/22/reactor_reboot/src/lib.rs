use std::{
  collections::{HashSet, VecDeque},
  fs,
};

mod cuboid;
use cuboid::Cuboid;

/// Count the amount of cubes which are on.
pub fn count_cubes(filename: &String, subspace: i64) -> i64 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");

  // Get list of cuboids (which are inside the subspace)
  let cuboids: Vec<Cuboid> = contents
    .lines()
    .map(|line| Cuboid::from(line))
    .filter(|cub| cub.is_inside(subspace))
    .collect();

  let mut lit_cuboids: HashSet<Cuboid> = HashSet::new();
  let mut cuboid_queue: VecDeque<Cuboid> = VecDeque::new();
  for cuboid in cuboids.iter() {
    let mut old_cuboid: Option<Cuboid> = None;
    let mut new_cuboids: Vec<Cuboid> = Vec::new();

    cuboid_queue.push_back(*cuboid);
    while !cuboid_queue.is_empty() {
      let current_cuboid = cuboid_queue.pop_front().unwrap();
      let mut no_intersection = true;
      for lit_cuboid in lit_cuboids.iter() {
        if current_cuboid.on && current_cuboid == *lit_cuboid {
          no_intersection = false;
          break;
        }

        let intersection = lit_cuboid.get_intersection(&current_cuboid);
        if intersection.is_some() {
          no_intersection = false;
          if intersection.unwrap() == *lit_cuboid {
            old_cuboid = Some(*lit_cuboid);
            cuboid_queue.push_front(current_cuboid);
          } else {
            if current_cuboid.on {
              if intersection.unwrap() != current_cuboid {
                current_cuboid
                  .remove_and_split(&intersection.unwrap())
                  .iter()
                  .for_each(|&cub| cuboid_queue.push_back(cub));
              }
            } else {
              lit_cuboid
                .remove_and_split(&intersection.unwrap())
                .iter()
                .for_each(|&cub| cuboid_queue.push_back(cub));
              old_cuboid = Some(*lit_cuboid);
              cuboid_queue.push_front(current_cuboid);
            }
          }

          break;
        }
      }

      // Remove cuboids
      if old_cuboid.is_some() {
        lit_cuboids.remove(&old_cuboid.unwrap());
      }

      if no_intersection && current_cuboid.on {
        new_cuboids.push(current_cuboid);
      }
    }

    // Add cuboids
    for cub in new_cuboids {
      lit_cuboids.insert(cub);
    }
  }

  return lit_cuboids.iter().map(|cub| cub.volume()).sum();
}
