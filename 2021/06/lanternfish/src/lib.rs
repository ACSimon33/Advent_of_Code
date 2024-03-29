use std::fs;

/// Calculate the amount of lanternfish after a certain number of days.
pub fn lanternfish(filename: &String, days: &i128) -> i128 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let fish: Vec<i128> =
    contents.split(",").map(|x| x.parse().unwrap()).collect();

  let mut population: i128 = 0;
  for fish_age in 0..6 {
    let mut single_populations: Vec<i128> = vec![-1; *days as usize];
    population += fish.iter().filter(|&f| *f == fish_age).count() as i128
      * get_single_fish_population(&fish_age, &days, &mut single_populations);
  }

  return population;
}

/// Calculate the population originating from a single fish.
fn get_single_fish_population(
  fish: &i128,
  days: &i128,
  single_populations: &mut Vec<i128>,
) -> i128 {
  let mut population: i128 = 1;
  let mut current_day: i128 = days - fish - 1;
  while current_day >= 0 {
    let idx = current_day as usize;
    if single_populations[idx] == -1 {
      single_populations[idx] =
        get_single_fish_population(&0, &(current_day - 8), single_populations);
    }

    population += single_populations[idx];
    current_day -= 7;
  }
  return population;
}
