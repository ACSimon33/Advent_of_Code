//! Naive solution which will only solve part 1.

use std::fs;
use std::collections::HashMap;

/// First task.
pub fn get_elements(filename: &String, steps: &usize) -> HashMap<char, usize> {
  let (template, rules) = parse(filename);

  // Simulate
  let polymer = simulate(steps, &rules, &template);

  // Get all unique chars
  let mut chars: Vec<char> = polymer.chars().collect();
  chars.sort_unstable();
  chars.dedup();

  return chars.iter().map(|c| (*c, polymer.matches(*c).count())).collect();
}

/// Parse input.
pub fn parse(filename: &String) -> (String, HashMap<String, String>) {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  // Parse template
  let template: String = lines.iter().nth(0).unwrap().to_string();

  // Parse rules
  let mut rules: HashMap<String, String> = lines.iter()
    .filter(|line| line.split(" -> ").count() == 2)
    .map(|line| line.split_once(" -> ").unwrap())
    .map(|(rule, repl)| (rule.to_string(), repl.to_string()))
    .collect();

  for (rule, repl) in rules.iter_mut() {
    let chars: Vec<char> = rule.chars().collect();
    repl.insert(0, chars[0]);
    repl.insert(repl.len(), chars[1]);
  }

  return (template, rules);
}

/// Simulates the growth of a polymer.
fn simulate(
  steps: &usize, rules: &HashMap<String, String>, template: &String
) -> String {

  let mut polymer: String = template.clone();
  let mut extenced_rules: HashMap<String, String> = HashMap::new();

  if *steps > 0 {
    // Check which rule we need and simulate them recursively
    for (rule, repl) in rules.iter() {
      if template.contains(rule) {
        extenced_rules.insert(
          rule.clone(), simulate(&(steps-1), rules, &repl));
      }
    }

    // Replace the simulated rules
    let mut idx: usize = 0;
    let mut found: bool;
    while idx < polymer.len()-1 {
      found = false;
      for (rule, repl) in extenced_rules.iter() {
        if rule.as_str() == &polymer[idx..idx+rule.len()] {
          polymer.replace_range(idx..idx+rule.len(), repl);
          idx += repl.len()-1;
          found = true;
          break;
        }
      }
      if !found {
        idx += 1;
      }
    } 
  }

  return polymer;
}
