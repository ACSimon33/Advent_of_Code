use regex::Regex;
use std::cmp;

/// A Point in 3D space.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct Point {
  pub x: i64,
  pub y: i64,
  pub z: i64,
}

/// A Cuboid in 3D space.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct Cuboid {
  pub on: bool,
  pub lb: Point,
  pub ub: Point,
}

impl Cuboid {
  /// Create a new Cuboid.
  pub fn new(on: bool, lb: Point, ub: Point) -> Cuboid {
    Cuboid { on: on, lb: lb, ub: ub }
  }

  /// Create the intersection cuboid between two cuboids.
  pub fn get_intersection(&self, other: &Cuboid) -> Option<Cuboid> {
    let lb = Point {
      x: cmp::max(self.lb.x, other.lb.x),
      y: cmp::max(self.lb.y, other.lb.y),
      z: cmp::max(self.lb.z, other.lb.z),
    };
    let ub = Point {
      x: cmp::min(self.ub.x, other.ub.x),
      y: cmp::min(self.ub.y, other.ub.y),
      z: cmp::min(self.ub.z, other.ub.z),
    };

    if lb.x <= ub.x && lb.y <= ub.y && lb.z <= ub.z {
      Some(Cuboid::new(true, lb, ub))
    } else {
      None
    }
  }

  /// Remove an intersection from this cuboid and return the rest of it as a
  /// list of cuboids.
  pub fn remove_and_split(&self, intersection: &Cuboid) -> Vec<Cuboid> {
    let mut sub_cuboids: Vec<Cuboid> = Vec::new();

    if self.lb.x < intersection.lb.x {
      sub_cuboids.push(Cuboid::new(
        true,
        self.lb,
        Point { x: intersection.lb.x - 1, y: self.ub.y, z: self.ub.z },
      ));
    }

    if self.ub.x > intersection.ub.x {
      sub_cuboids.push(Cuboid::new(
        true,
        Point { x: intersection.ub.x + 1, y: self.lb.y, z: self.lb.z },
        self.ub,
      ));
    }

    if self.lb.y < intersection.lb.y {
      sub_cuboids.push(Cuboid::new(
        true,
        Point { x: intersection.lb.x, y: self.lb.y, z: self.lb.z },
        Point { x: intersection.ub.x, y: intersection.lb.y - 1, z: self.ub.z },
      ));
    }

    if self.ub.y > intersection.ub.y {
      sub_cuboids.push(Cuboid::new(
        true,
        Point { x: intersection.lb.x, y: intersection.ub.y + 1, z: self.lb.z },
        Point { x: intersection.ub.x, y: self.ub.y, z: self.ub.z },
      ));
    }

    if self.lb.z < intersection.lb.z {
      sub_cuboids.push(Cuboid::new(
        true,
        Point { x: intersection.lb.x, y: intersection.lb.y, z: self.lb.z },
        Point {
          x: intersection.ub.x,
          y: intersection.ub.y,
          z: intersection.lb.z - 1,
        },
      ));
    }

    if self.ub.z > intersection.ub.z {
      sub_cuboids.push(Cuboid::new(
        true,
        Point {
          x: intersection.lb.x,
          y: intersection.lb.y,
          z: intersection.ub.z + 1,
        },
        Point { x: intersection.ub.x, y: intersection.ub.y, z: self.ub.z },
      ));
    }

    sub_cuboids
  }

  /// Calculate the volume of this cuboid.
  pub fn volume(&self) -> i64 {
    (1 + self.ub.x - self.lb.x)
      * (1 + self.ub.y - self.lb.y)
      * (1 + self.ub.z - self.lb.z)
  }

  /// Check if this cuboid is inside a certain cubic subspace.
  pub fn is_inside(&self, subspace: i64) -> bool {
    if subspace > 0 {
      self.lb.x >= -subspace
        && self.lb.x <= subspace
        && self.lb.y >= -subspace
        && self.lb.y <= subspace
        && self.lb.z >= -subspace
        && self.lb.z <= subspace
    } else {
      true
    }
  }
}

impl From<&str> for Cuboid {
  /// Create a Cuboid from a str reference.
  fn from(str: &str) -> Cuboid {
    let re = Regex::new(
      r"(on|off)+ x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)",
    )
    .unwrap();
    let cap = re.captures(str).unwrap();

    let on = cap.get(1).unwrap().as_str() == "on";
    let lb = Point {
      x: cap.get(2).unwrap().as_str().parse().unwrap(),
      y: cap.get(4).unwrap().as_str().parse().unwrap(),
      z: cap.get(6).unwrap().as_str().parse().unwrap(),
    };
    let ub = Point {
      x: cap.get(3).unwrap().as_str().parse().unwrap(),
      y: cap.get(5).unwrap().as_str().parse().unwrap(),
      z: cap.get(7).unwrap().as_str().parse().unwrap(),
    };
    Cuboid::new(on, lb, ub)
  }
}
