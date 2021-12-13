use std::fs;

mod syntax_checker;
use syntax_checker::SyntaxChecker;

/// Returns the error score
pub fn error_score(filename: &String) -> i64 {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  let mut score: i64 = 0;

  let mut syntax: SyntaxChecker = SyntaxChecker::new();
  for line in lines.iter() {
    score += syntax.parse(line);
  }

  return score;
}

/// Returns the completion score
pub fn completion_score(filename: &String) -> i64 {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  let mut scores: Vec<i64> = Vec::new();

  let mut syntax: SyntaxChecker = SyntaxChecker::new();
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
  use super::{error_score, completion_score};
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
