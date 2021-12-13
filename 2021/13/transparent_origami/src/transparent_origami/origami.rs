use std::cmp::Ordering;

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Point {
  pub x: i32,
  pub y: i32
}

impl Point {
  pub fn new(x_coord: i32, y_coord: i32) -> Point {
    Point {
      x: x_coord,
      y: y_coord
    }
  }
}

impl PartialOrd for Point {
  fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
    Some(self.cmp(other))
  }
}

impl Ord for Point {
  fn cmp(&self, other: &Self) -> Ordering {
    // Try y coordinates first
    let y_order = self.y.cmp(&other.y);
    if y_order != Ordering::Equal {
      return y_order;
    }
    // Use x order if y coordinates are equal
    return self.x.cmp(&other.x);
  }
}

#[derive(Clone, Debug, PartialEq)]
pub enum FoldDirection {
  HORIZONTAL,
  VERTICAL
}

#[derive(Clone, Debug)]
pub struct Fold {
  pub value: i32,
  pub direction: FoldDirection
}

impl Fold {
  pub fn new(fold_value: i32, fold_direction: &str) -> Fold {
    if fold_direction == "x" {
      return Fold {
        value: fold_value,
        direction: FoldDirection::HORIZONTAL
      }
    } else if fold_direction == "y" {
      return Fold {
        value: fold_value,
        direction: FoldDirection::VERTICAL
      }
    } 
    panic!("Error: Unknown fold direction.");
  }

  pub fn apply_to_point(&self, p: &mut Point) {
    if self.direction == FoldDirection::HORIZONTAL && p.x > self.value {
      p.x -= 2 * (p.x - self.value);
    } else if self.direction == FoldDirection::VERTICAL && p.y > self.value {
      p.y -= 2 * (p.y - self.value);
    }
  }
}

#[derive(Clone, Debug)]
pub struct Sheet {
  pub points: Vec<Point>,
  pub top_left: Point,
  pub bottom_right: Point
}

impl Sheet {
  pub fn new(points: Vec<Point>) -> Sheet{
    let mut sheet = Sheet {
      points: points,
      top_left: Point::new(i32::MIN, i32::MIN),
      bottom_right: Point::new(i32::MAX, i32::MAX)
    };
    sheet.shrink_to_fit();
    return sheet;
  }

  pub fn fold(&mut self, f: &Fold) {
    // Apply single fold
    for point in self.points.iter_mut() {
      f.apply_to_point(point);
    }

    // Remove duplicates and shrink to fit
    self.points.sort_unstable();
    self.points.dedup();
    self.shrink_to_fit();
  }

  pub fn fold_all(&mut self, folds: &Vec<Fold>) {
    // Apply all folds
    for f in folds.iter() {
      self.fold(f);
    }
  }

  pub fn shrink_to_fit(&mut self) {
    self.top_left = Point::new(
      self.points.iter().map(|p| p.x).min().unwrap(),
      self.points.iter().map(|p| p.y).min().unwrap()
    );
    self.bottom_right = Point::new(
      self.points.iter().map(|p| p.x).max().unwrap(),
      self.points.iter().map(|p| p.y).max().unwrap()
    );
  }

  pub fn count_points(&self) -> usize {
    return self.points.len();
  }

  pub fn check_coords(&self, x: i32, y: i32) -> bool {
    return self.points.contains(&Point::new(x, y));
  }

  pub fn to_string(&self) -> String {
    let mut s: String = String::new();
    for y in self.top_left.y .. self.bottom_right.y+1 {
      for x in self.top_left.x .. self.bottom_right.x+1 {
        if self.check_coords(x, y) {
          s += "#";
        } else {
          s += ".";
        }
      }
      s += "\n";
    }

    return s;
  }
}