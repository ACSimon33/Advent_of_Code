/// Single pair in the polymer
#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub struct Pair {
  pub first: char,
  pub second: char
}

impl Pair {
  /// Create a new pair from two chars
  pub fn new(first: &char, second: &char) -> Pair {
    Pair {
      first: *first,
      second: *second
    }
  }

  /// Create a new pair from a string
  pub fn from_str(pair_str: &str) -> Pair {
    Pair::new(
      &pair_str.chars().nth(0).unwrap(),
      &pair_str.chars().nth(1).unwrap()
    )
  }
}

/// Polymer conversion rule
#[derive(Clone, Debug)]
pub struct Rule {
  pub pair: Pair,
  pub insert: char
}

impl Rule {
  /// Create a new rule from an input line
  pub fn new(line: &str) -> Rule {
    let (pair_str, insert_str) = line.split_once(" -> ").unwrap();
    Rule {
      pair: Pair::from_str(pair_str),
      insert: insert_str.chars().nth(0).unwrap()
    }
  }

  // Return a list of new pairs, crated by the rule
  pub fn get_new_pairs(&self) -> Vec<Pair> {
    vec![
      Pair::new(&self.pair.first, &self.insert),
      Pair::new(&self.insert, &self.pair.second)]
  }
}
