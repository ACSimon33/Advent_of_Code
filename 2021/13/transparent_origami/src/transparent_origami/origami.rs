use std::cmp::Ordering;

/// Point struct.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Point {
  pub x: i32,
  pub y: i32
}

impl Point {
  /// Create a new point.
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
  /// Row major order for points.
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

/// The direction of a fold.
#[derive(Clone, Debug, PartialEq)]
pub enum FoldDirection {
  HORIZONTAL,
  VERTICAL
}

/// Fold with a fold position and direction.
#[derive(Clone, Debug)]
pub struct Fold {
  pub value: i32,
  pub direction: FoldDirection
}

impl Fold {
  /// Create a new fold.
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

  /// Apply the fold to a point.
  pub fn apply_to_point(&self, p: &mut Point) {
    if self.direction == FoldDirection::HORIZONTAL && p.x > self.value {
      p.x -= 2 * (p.x - self.value);
    } else if self.direction == FoldDirection::VERTICAL && p.y > self.value {
      p.y -= 2 * (p.y - self.value);
    }
  }
}

/// Sheet with a point cloud.
#[derive(Clone, Debug)]
pub struct Sheet {
  pub points: Vec<Point>,
  pub top_left: Point,
  pub bottom_right: Point
}

impl Sheet {
  /// Create a new sheet from a point cloud.
  pub fn new(points: Vec<Point>) -> Sheet{
    let mut sheet = Sheet {
      points: points,
      top_left: Point::new(i32::MIN, i32::MIN),
      bottom_right: Point::new(i32::MAX, i32::MAX)
    };
    sheet.shrink_to_fit();
    return sheet;
  }

  /// Fold the sheet.
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

  /// Apply multiple folds.
  pub fn fold_all(&mut self, folds: &Vec<Fold>) {
    for f in folds.iter() {
      self.fold(f);
    }
  }

  /// Shrink the bounds of the paper.
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

  /// Return the amount of points.
  pub fn count_points(&self) -> usize {
    return self.points.len();
  }

  /// Check if the sheet contains a certain point.
  pub fn check_coords(&self, x: i32, y: i32) -> bool {
    return self.points.contains(&Point::new(x, y));
  }

  /// Print the sheet.
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