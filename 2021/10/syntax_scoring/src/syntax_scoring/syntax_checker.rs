use phf::phf_map;

/// Error score per bracket.
static ERROR_SCORE: phf::Map<char, i64> = phf_map! {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
};

/// Completion score per bracket.
static COMPLETION_SCORE: phf::Map<char, i64> = phf_map! {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4
};

/// Matching brackets.
static MATCHING_BRACKET: phf::Map<char, char> = phf_map! {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<'
};

/// Syntax checker, that can parse and complete lines as well compute
/// the error and completion scores. Uses a stack to keep track of tokens.
#[derive(Debug)]
pub struct SyntaxChecker {
  pub stack: Vec<char>
}

impl SyntaxChecker {
  /// Create a new empty syntax checker.
  pub fn new() -> SyntaxChecker {
    SyntaxChecker {
      stack: Vec::new(),
    }
  }

  /// Parses a single input line and returns the error score for that line.
  pub fn parse(&mut self, line: &str) -> i64 {
    self.stack.clear();

    // Parse line
    for c in line.chars() {
      match c {
        '(' | '[' | '{' | '<' => self.stack.push(c),
        ')' | ']' | '}' | '>' => {
          if self.stack.pop().unwrap() != MATCHING_BRACKET[&c] {
            return ERROR_SCORE[&c];
          }
        }
        _ => panic!("Unknown character: '{}'", c)
      }
    }
    return 0;
  }

  /// Completes a single input line and returns the completion score.
  pub fn complete(&mut self) -> i64 {
    let mut score: i64 = 0;
    let mut c: char;
    while self.stack.len() > 0 {
      c = self.stack.pop().unwrap();
      score *= 5;
      score += COMPLETION_SCORE[&c];
    }
    return score;
  }
}
