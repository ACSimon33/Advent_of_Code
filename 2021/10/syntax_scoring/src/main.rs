use std::fs;
use std::env;

mod syntax_checker;
use syntax_checker::SyntaxChecker;
use syntax_checker::create_syntax_checker;

fn main() {
  let args: Vec<String> = env::args().collect();
  let filename: &String = &args[1];

  let e_score = error_score(&filename);
  println!("1. Error score: {}", e_score);

  let c_score = completion_score(&filename);
  println!("2. Completion score: {}", c_score);
}

fn error_score(filename: &String) -> i64 {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  let mut score: i64 = 0;

  let mut syntax: SyntaxChecker = create_syntax_checker();
  for line in lines.iter() {
    score += syntax.parse(line);
  }

  return score;
}

fn completion_score(filename: &String) -> i64 {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  let mut scores: Vec<i64> = Vec::new();

  let mut syntax: SyntaxChecker = create_syntax_checker();
  for line in lines.iter() {
    if syntax.parse(line) == 0 {
      scores.push(syntax.complete());
    };
  }

  scores.sort();
  return scores[scores.len() / 2];
}

#[cfg(test)]
mod tests {
  use super::*;
  const INPUT_FILENAME: &str = "input/example_input.txt";

  #[test]
  fn test_1() {
    let score = error_score(&INPUT_FILENAME.to_string());
    assert_eq!(score, 26397);
  }

  #[test]
  fn test_2() {
    let score = completion_score(&INPUT_FILENAME.to_string());
    assert_eq!(score, 288957);
  }
}

