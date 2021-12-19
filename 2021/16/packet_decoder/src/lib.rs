use std::fs;

mod decoder;
use decoder::Decoder;

/// Part1: Calulate the sum of all version numbers
pub fn version_numbers(filename: &String) -> u64 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");

  let dec = Decoder::new(&contents);
  return dec.version_sum();
}

/// Part2: Evaluate the expression tree
pub fn evaluate(filename: &String) -> u64 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");

  let dec = Decoder::new(&contents);
  return dec.evaluate();
}
