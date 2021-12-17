use std::cmp;
use std::collections::HashMap;
use num::range_step_inclusive;
use num::range_inclusive;

/// A point.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Point {
  pub x: i32,
  pub y: i32
}

impl Point {
  /// Create a new point from a string.
  fn new(s: &str) -> Point {
    let coords: Vec<i32> = s.split(",").map(|x| x.parse().unwrap()).collect();
    Point {
      x: coords[0],
      y: coords[1]
    }
  }
}

/// Line between two points.
#[derive(Clone, Debug)]
pub struct Line {
  pub start: Point,
  pub end: Point
}

impl Line {
  /// Create line from a string.
  fn new(s: &str) -> Line {
    let points: Vec<Point> = s.split(" -> ").map(|x| Point::new(x)).collect();
    Line {
      start: points[0],
      end: points[1]
    }
  }

  /// Get the maximum x coordinate.
  fn max_x(&self) -> usize {
    cmp::max(self.start.x, self.end.x) as usize
  }

  /// Get the maximum y coordinate.
  fn max_y(&self) -> usize {
    cmp::max(self.start.y, self.end.y) as usize
  }

  /// Check if line is horizontal.
  fn is_horizontal(&self) -> bool {
    self.start.y == self.end.y
  }

  /// Check if line is horizontal.
  fn is_vertical(&self) -> bool {
    self.start.x == self.end.x
  }

  /// Check if line is straight (vertical or horizontal).
  fn is_straight(&self) -> bool {
    self.is_horizontal() || self.is_vertical()
  }

  /// Create a vector of all points on the line.
  fn fill_in_points(&self) -> Vec<Point> {
    let mut points: Vec<Point> = Vec::new();
    let x_step = (self.end.x - self.start.x).signum();
    let y_step = (self.end.y - self.start.y).signum();

    if self.is_horizontal() {
      for current_x in range_step_inclusive(self.start.x, self.end.x, x_step) {
        points.push(Point {x: current_x, y: self.start.y});
      }
    } else if self.is_vertical() {
      for current_y in range_step_inclusive(self.start.y, self.end.y, y_step) {
        points.push(Point {x: self.start.x, y: current_y});
      }
    } else {
      for i in range_inclusive(0, (self.end.x - self.start.x) / x_step) {
        points.push(Point {
          x: self.start.x + i*x_step,
          y: self.start.y + i*y_step
        });
      }
    }

    return points;
  }
}

/// The sea floor.
#[derive(Clone, Debug)]
pub struct SeaFloor {
  pub vents: Vec<Line>,
  pub m: usize,
  pub n: usize
}

impl SeaFloor {
  /// Create sea floor from a string.
  pub fn new(lines: &Vec<&str>) -> SeaFloor {
    let mut seafloor = SeaFloor {
      vents: lines.iter().map(|x| Line::new(x)).collect(),
      m: 0,
      n: 0
    };

    seafloor.m = seafloor.vents.iter().map(|l| l.max_y()).max().unwrap();
    seafloor.n = seafloor.vents.iter().map(|l| l.max_x()).max().unwrap();
    return seafloor;
  }

  /// Create an intensity map.
  pub fn create_point_cloud(&self, straight: bool) -> HashMap<usize, i32> {
    let mut intensity: HashMap<usize, i32> = HashMap::new();

    for line in self.vents.iter().filter(|x| !straight || x.is_straight()) {
      for p in line.fill_in_points().iter() {
        let idx = (p.y as usize) * self.n + (p.x as usize);
        *intensity.entry(idx).or_default() += 1;
      }
    }

    return intensity;
  }
}
