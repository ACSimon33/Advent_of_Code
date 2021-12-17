extern crate num;

use std::cmp::PartialEq;
use num::range_step_inclusive;
use num::range_inclusive;

#[derive(Clone, Copy, Debug)]
pub struct Point {
  pub x: i32,
  pub y: i32,
  pub intensity: i32
}

impl Point {
  fn new(s: &str) -> Point {
    let coords: Vec<i32> = s.split(",").map(|x| x.parse().unwrap()).collect();
    Point {
      x: coords[0],
      y: coords[1],
      intensity: 1
    }
  }
}

impl PartialEq<Point> for Point {
  fn eq(&self, other: &Self) -> bool {
    self.x == other.x && self.y == other.y
  }
}

#[derive(Clone, Debug)]
pub struct Line {
  pub start: Point,
  pub end: Point
}

impl Line {
  fn new(s: &str) -> Line {
    let points: Vec<Point> = s.split(" -> ").map(|x| Point::new(x)).collect();
    Line {
      start: points[0],
      end: points[1]
    }
  }

  fn is_horizontal(&self) -> bool {
    self.start.y == self.end.y
  }

  fn is_vertical(&self) -> bool {
    self.start.x == self.end.x
  }

  fn is_straight(&self) -> bool {
    self.is_horizontal() || self.is_vertical()
  }

  fn fill_in_points(&self) -> Vec<Point> {
    let mut points: Vec<Point> = Vec::new();
    let x_step = (self.end.x - self.start.x).signum();
    let y_step = (self.end.y - self.start.y).signum();

    if self.is_horizontal() {
      for current_x in range_step_inclusive(self.start.x, self.end.x, x_step) {
        points.push(Point {x: current_x, y: self.start.y, intensity: 1});
      }
    } else if self.is_vertical() {
      for current_y in range_step_inclusive(self.start.y, self.end.y, y_step) {
        points.push(Point {x: self.start.x, y: current_y, intensity: 1});
      }
    } else {
      for i in range_inclusive(0, (self.end.x - self.start.x) / x_step) {
        points.push(Point {
          x: self.start.x + i*x_step,
          y: self.start.y + i*y_step,
          intensity: 1
        });
      }
    }

    return points;
  }
}

#[derive(Clone, Debug)]
pub struct SeaFloor {
  pub vents: Vec<Line>
}

impl SeaFloor {
  pub fn new(lines: &Vec<&str>) -> SeaFloor {
    SeaFloor {
      vents: lines.iter().map(|x| Line::new(x)).collect()
    }
  }

  pub fn create_point_cloud(&self, straight: bool) -> Vec<Point> {
    let mut point_cloud: Vec<Point> = Vec::new();
    for line in self.vents.iter().filter(|x| !straight || x.is_straight()) {
      for new_p in line.fill_in_points().iter() {
        let mut duplicate: bool = false;
        for i in 0 .. point_cloud.len() {
          if point_cloud[i] == *new_p {
            point_cloud[i].intensity += 1;
            duplicate = true;
            break;
          }
        }

        if !duplicate {
          point_cloud.push(*new_p);
        }
      }
    }

    return point_cloud;
  }
}
