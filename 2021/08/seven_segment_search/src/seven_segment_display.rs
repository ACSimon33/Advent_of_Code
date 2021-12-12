
use std::collections::HashMap;

#[derive(Clone, Debug)]
pub struct SevenSegmentDisplay {
  pub mapping: HashMap<char, char>
}

impl SevenSegmentDisplay {
  pub fn init(&mut self, line: &str) {
    let digits: Vec<&str> = line.split_whitespace().collect();
    let mut letter_count: std::collections::HashMap<char, i32> =
      std::collections::HashMap::new();

    // Count letter_count in all 10 configurations
    for digit in digits.iter() {
      for c in digit.chars() {
        let counter = letter_count.entry(c).or_insert(0);
        *counter += 1;
      }
    }

    // Deduce b (6), e (4) and f (9)
    self.mapping.insert(
      *letter_count.iter().filter(|(_, &count)| count == 6)
        .nth(0).unwrap().0, 'b'
    );
    self.mapping.insert(
      *letter_count.iter().filter(|(_, &count)| count == 4)
        .nth(0).unwrap().0, 'e'
    );
    self.mapping.insert(
      *letter_count.iter().filter(|(_, &count)| count == 9)
        .nth(0).unwrap().0, 'f'
    );

    // Deduce c (search for 1)
    for c in digits.iter().filter(|d| d.len() == 2).nth(0).unwrap().chars() {
      if !self.mapping.contains_key(&c) {
        self.mapping.insert(c, 'c');
      }
    }

    // Deduce a (search for 7)
    for c in digits.iter().filter(|d| d.len() == 3).nth(0).unwrap().chars() {
      if !self.mapping.contains_key(&c) {
        self.mapping.insert(c, 'a');
      }
    }

    // Deduce d (search for 4)
    for c in digits.iter().filter(|d| d.len() == 4).nth(0).unwrap().chars() {
      if !self.mapping.contains_key(&c) {
        self.mapping.insert(c, 'd');
      }
    }

    // Deduce g (search for 8)
    for c in digits.iter().filter(|d| d.len() == 7).nth(0).unwrap().chars() {
      if !self.mapping.contains_key(&c) {
        self.mapping.insert(c, 'g');
        break;
      }
    }
  }

  pub fn convert_number(&self, num: &str) -> i32 {
    let mut segments: Vec<char> = num.chars()
      .map(|c| self.mapping[&c]).collect();
    segments.sort();
    if segments == ['a', 'b', 'c', 'e', 'f', 'g'] {
      return 0;
    } else if segments == ['c', 'f'] {
      return 1;
    } else if segments == ['a', 'c', 'd', 'e', 'g'] {
      return 2;
    } else if segments == ['a', 'c', 'd', 'f', 'g'] {
      return 3;
    } else if segments == ['b', 'c', 'd', 'f'] {
      return 4;
    } else if segments == ['a', 'b', 'd', 'f', 'g'] {
      return 5;
    } else if segments == ['a', 'b', 'd', 'e', 'f', 'g'] {
      return 6;
    } else if segments == ['a', 'c', 'f'] {
      return 7;
    } else if segments == ['a', 'b', 'c', 'd', 'e', 'f', 'g'] {
      return 8;
    } else if segments == ['a', 'b', 'c', 'd', 'f', 'g'] {
      return 9;
    } else {
      panic!("Unkown number!")
    }
  }

}

pub fn create_seven_segment_display() -> SevenSegmentDisplay {
  SevenSegmentDisplay {
    mapping: HashMap::new(),
  }
}