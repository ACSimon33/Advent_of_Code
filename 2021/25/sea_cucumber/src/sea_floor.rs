use phf::phf_map;

/// Cucumber types.
#[derive(Clone, Copy, Debug, PartialEq)]
pub enum Cucumber {
  None = 0,
  EastFacing = 1,
  SouthFacing = 2,
}

/// Mapping of cucumbers.
static CUCUMBER_MAP: phf::Map<char, Cucumber> = phf_map! {
  '.' => Cucumber::None,
  '>' => Cucumber::EastFacing,
  'v' => Cucumber::SouthFacing,
};

/// The sea floor.
#[derive(Clone, Debug)]
pub struct SeaFloor {
  pub grid: Vec<Cucumber>,
  pub m: usize,
  pub n: usize,
}

impl SeaFloor {
  /// Let all cucumbers that can move, make a step.
  pub fn step(&mut self) -> bool {
    // Move east facing cucumbers
    let east_cucumbers: Vec<usize> = self
      .grid
      .iter()
      .enumerate()
      .filter(|(_, &c)| c == Cucumber::EastFacing)
      .filter(|(idx, _)| {
        let i = *idx / self.n;
        let j = *idx % self.n;
        self.grid[i * self.n + (j + 1) % self.n] == Cucumber::None
      })
      .map(|(idx, _)| idx)
      .collect();

    east_cucumbers.iter().for_each(|idx| {
      let i = *idx / self.n;
      let j = *idx % self.n;
      self.grid[*idx] = Cucumber::None;
      self.grid[i * self.n + (j + 1) % self.n] = Cucumber::EastFacing;
    });

    // Move south facing cucumbers
    let south_cucumbers: Vec<usize> = self
      .grid
      .iter()
      .enumerate()
      .filter(|(_, &c)| c == Cucumber::SouthFacing)
      .filter(|(idx, _)| {
        let i = *idx / self.n;
        let j = *idx % self.n;
        self.grid[(i + 1) % self.m * self.n + j] == Cucumber::None
      })
      .map(|(idx, _)| idx)
      .collect();

    south_cucumbers.iter().for_each(|idx| {
      let i = *idx / self.n;
      let j = *idx % self.n;
      self.grid[*idx] = Cucumber::None;
      self.grid[(i + 1) % self.m * self.n + j] = Cucumber::SouthFacing;
    });

    return !east_cucumbers.is_empty() || !south_cucumbers.is_empty();
  }
}

impl From<String> for SeaFloor {
  /// Parse the input and initialize the sea floor.
  fn from(string: String) -> SeaFloor {
    SeaFloor {
      grid: string
        .lines()
        .flat_map(|line| line.chars().map(|c| CUCUMBER_MAP[&c]))
        .collect(),
      m: string.lines().count(),
      n: string.lines().nth(0).unwrap().len(),
    }
  }
}
