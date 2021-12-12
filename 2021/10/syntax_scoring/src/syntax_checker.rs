
#[derive(Clone, Debug)]
pub struct SyntaxChecker {
  pub stack: Vec<char>
}

impl SyntaxChecker {
  pub fn parse(&mut self, line: &str) -> i64 {
    self.stack.clear();

    // Parse line
    for c in line.chars() {
      match c {
        '(' | '[' | '{' | '<' => self.stack.push(c),
        ')' | ']' | '}' | '>' => {
          if self.stack.pop().unwrap() != self.expected_char(&c) {
            return self.error_score(&c);
          }
        }
        _ => panic!("Unknown character: '{}'", c)
      }
    }
    return 0;
  }

  pub fn complete(&mut self) -> i64 {
    let mut score: i64 = 0;
    let mut c: char;
    while self.stack.len() > 0 {
      c = self.stack.pop().unwrap();
      score *= 5;
      score += self.completion_score(&c);
    }
    return score;
  }

  pub fn expected_char(&self, c: &char) -> char {
    match c {
      ')' => return '(',
      ']' => return '[',
      '}' => return '{',
      '>' => return '<',
      _ => panic!("Unknown character: '{}'", c)
    }
  }

  pub fn error_score(&self, c: &char) -> i64 {
    match c {
      ')' => return 3,
      ']' => return 57,
      '}' => return 1197,
      '>' => return 25137,
      _ => panic!("Unknown character: '{}'", c)
    }
  }

  pub fn completion_score(&self, c: &char) -> i64 {
    match c {
      '(' => return 1,
      '[' => return 2,
      '{' => return 3,
      '<' => return 4,
      _ => panic!("Unknown character: '{}'", c)
    }
  }

}

pub fn create_syntax_checker() -> SyntaxChecker {
  SyntaxChecker {
    stack: Vec::new(),
  }
}