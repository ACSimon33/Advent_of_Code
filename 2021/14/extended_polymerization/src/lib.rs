use std::collections::HashMap;
use std::fs;

mod polymer;
use polymer::Pair;
use polymer::Rule;

/// Return a list of char counts after a given amount of steps
pub fn get_elements(filename: &String, steps: &usize) -> HashMap<char, i64> {
  let (mut pairs, rules, boundaries) = parse(filename);

  // Simulate
  simulate(steps, &rules, &mut pairs);

  // Get all unique char counts
  let mut char_count: HashMap<char, i64> = HashMap::new();
  for (pair, count) in pairs {
    *char_count.entry(pair.first).or_default() += count;
    *char_count.entry(pair.second).or_default() += count;
  }

  // Add first and last char
  *char_count.entry(boundaries.first).or_default() += 1;
  *char_count.entry(boundaries.second).or_default() += 1;

  return char_count
    .iter()
    .map(|(c, count)| (*c, count / 2))
    .collect();
}

/// Parse the input file.
pub fn parse(filename: &String) -> (HashMap<Pair, i64>, Vec<Rule>, Pair) {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  // Parse template
  let template = lines.iter().nth(0).unwrap();
  let mut pairs: HashMap<Pair, i64> = HashMap::new();
  for (first, second) in template.chars().zip(template.chars().skip(1)) {
    *pairs.entry(Pair::new(&first, &second)).or_default() += 1;
  }

  // Get first / last pair
  let boundaries = Pair::new(
    &template.chars().next().unwrap(),
    &template.chars().last().unwrap(),
  );

  // Parse rules
  let rules = lines
    .iter()
    .filter(|line| line.contains(" -> "))
    .map(|line| Rule::new(line))
    .collect();

  return (pairs, rules, boundaries);
}

/// Simulates the growth of a polymer.
fn simulate(steps: &usize, rules: &Vec<Rule>, pairs: &mut HashMap<Pair, i64>) {
  for _ in 0..*steps {
    let mut new_pairs = HashMap::new();
    for rule in rules.iter() {
      for (pair, count) in pairs.iter() {
        if *pair == rule.pair {
          for child in rule.get_new_pairs() {
            *new_pairs.entry(child).or_default() += *count;
          }
        }
      }
    }
    *pairs = new_pairs;
  }
}
