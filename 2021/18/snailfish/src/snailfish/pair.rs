use std::fmt;
use std::ops;

/// The id that determines if a pair contains a value or sub pairs.
#[derive(Clone, Debug, PartialEq)]
enum TypeID {
  PAIR,
  NUMBER,
}

/// Pair number.
#[derive(Clone, Debug, PartialEq)]
pub struct Pair {
  id: TypeID,
  pub sub_pairs: Vec<Pair>,
  pub value: i32,
}

impl Pair {
  /// Create with an optional value.
  pub fn new(val: Option<i32>) -> Pair {
    Pair {
      id: TypeID::NUMBER,
      sub_pairs: Vec::new(),
      value: val.unwrap_or_default(),
    }
  }

  /// Check if the pair is actually a number.
  fn contains_number(&self) -> bool {
    self.id == TypeID::NUMBER
  }

  /// Check if the pair is an actual pair.
  fn contains_pair(&self) -> bool {
    self.id == TypeID::PAIR
  }

  /// Returns a reference to the left most value.
  fn left_most_value(&mut self) -> &mut i32 {
    if self.contains_number() {
      return &mut self.value;
    } else {
      return self.sub_pairs[0].left_most_value();
    }
  }

  /// Returns a reference to the right most value.
  fn right_most_value(&mut self) -> &mut i32 {
    if self.contains_number() {
      return &mut self.value;
    } else {
      return self.sub_pairs[1].right_most_value();
    }
  }

  /// Reduce the pair number.
  pub fn reduce(&mut self) {
    loop {
      if self.explode(1).0 {
        continue;
      }
      if self.split() {
        continue;
      }
      break;
    }
  }

  /// Explode pairs with recursion depth >= 5.
  pub fn explode(&mut self, depth: usize) -> (bool, Option<i32>, Option<i32>) {
    if self.contains_pair() {
      if depth >= 5 {
        let left = self.sub_pairs[0].value;
        let right = self.sub_pairs[1].value;

        self.id = TypeID::NUMBER;
        self.sub_pairs.clear();
        self.value = 0;

        return (true, Some(left), Some(right));
      } else {
        let (exploded, left, right) = self.sub_pairs[0].explode(depth + 1);
        if exploded {
          if right.is_some() {
            *self.sub_pairs[1].left_most_value() += right.unwrap();
          }
          return (exploded, left, None);
        }

        let (exploded, left, right) = self.sub_pairs[1].explode(depth + 1);
        if exploded {
          if left.is_some() {
            *self.sub_pairs[0].right_most_value() += left.unwrap();
          }
          return (exploded, None, right);
        }
      }
    }

    return (false, None, None);
  }

  /// Split values >= 10.
  pub fn split(&mut self) -> bool {
    if self.contains_number() {
      if self.value >= 10 {
        self.id = TypeID::PAIR;
        self.sub_pairs.push(Pair::new(Some(self.value / 2)));
        self
          .sub_pairs
          .push(Pair::new(Some(self.value / 2 + self.value % 2)));
        self.value = 0;
        return true;
      }
    } else {
      return self.sub_pairs[0].split() || self.sub_pairs[1].split();
    }
    return false;
  }

  /// Caluclate the magnitude of the pair number.
  pub fn magnitude(&self) -> i32 {
    if self.contains_number() {
      self.value
    } else {
      3 * self.sub_pairs[0].magnitude() + 2 * self.sub_pairs[1].magnitude()
    }
  }
}

impl From<String> for Pair {
  /// Create a pair number from a string.
  fn from(string: String) -> Pair {
    let mut num: Pair = Pair::new(None);
    let mut bracket_count = 0;

    // Check for sub pairs
    for (idx, c) in string.chars().enumerate() {
      match c {
        '[' => bracket_count += 1,
        ']' => bracket_count -= 1,
        ',' => {
          if bracket_count == 1 {
            num.id = TypeID::PAIR;
            num.sub_pairs.push(Pair::from(string[1..idx].to_string()));
            num
              .sub_pairs
              .push(Pair::from(string[idx + 1..string.len() - 1].to_string()));
            break;
          }
        }
        _ => continue,
      }
    }

    // Init value if no sub pairs were found
    if num.contains_number() {
      num.value = string.parse().unwrap();
    }

    return num;
  }
}

impl ops::Add<&Pair> for &Pair {
  type Output = Pair;

  /// Addition of two pairs.
  fn add(self, rhs: &Pair) -> Pair {
    let mut num: Pair = Pair::new(None);
    num.id = TypeID::PAIR;
    num.sub_pairs.push(self.clone());
    num.sub_pairs.push(rhs.clone());
    num.reduce();
    return num;
  }
}

impl fmt::Display for Pair {
  // Implement output formatter for a pair.
  fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
    if self.contains_number() {
      write!(f, "{}", self.value)
    } else {
      write!(f, "[{},{}]", self.sub_pairs[0], self.sub_pairs[1])
    }
  }
}
