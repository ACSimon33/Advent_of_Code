use std::collections::HashMap;
use std::hash::Hash;
use std::mem;

/// Amount of unique facing directions.
const ORIENTATIONS: usize = 24;

/// Amount of overlapping beacons needed.
const BEACON_THRESHOLD: usize = 12;

/// A Vec3D with a relative position.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct Vec3D {
  pub x: i32,
  pub y: i32,
  pub z: i32,
  pub orientation: usize,
}

impl Vec3D {
  /// Create a new 3D Vector.
  pub fn new() -> Vec3D {
    Vec3D {
      x: 0,
      y: 0,
      z: 0,
      orientation: 0,
    }
  }

  /// Rotate Vec3D around the origin (which is some scanner).
  pub fn rotate(&mut self) {
    self.orientation += 1;
    let direction = self.orientation / 4;
    let rotation = self.orientation % 4;

    // Rotate around current axis (which is always x)
    rotate_90(&mut self.z, &mut self.y);

    // Rotate into new direction
    if rotation == 0 {
      if direction % 2 == 0 {
        rotate_90(&mut self.z, &mut self.x);
      } else {
        rotate_90(&mut self.x, &mut self.y);
      }
    }

    if self.orientation >= ORIENTATIONS {
      self.orientation = 0;
    }
  }
}

/// Rotate 90 degrees to the right.
fn rotate_90(a: &mut i32, b: &mut i32) {
  mem::swap(a, b);
  *a *= -1;
}

impl From<String> for Vec3D {
  /// Create a Vec3D from a string.
  fn from(string: String) -> Vec3D {
    let mut positions = string.split(",").map(|i| i.parse::<i32>().unwrap());
    let mut vec = Vec3D::new();
    vec.x = positions.next().unwrap();
    vec.y = positions.next().unwrap();
    vec.z = positions.next().unwrap();
    vec
  }
}

/// A scanner.
#[derive(Clone, Debug, PartialEq)]
pub struct Scanner {
  pub beacons: Vec<Vec3D>,
  pub merged: bool,
  pub position: Vec3D,
}

impl Scanner {
  /// Create a new scanner.
  pub fn new() -> Scanner {
    Scanner {
      beacons: Vec::new(),
      merged: false,
      position: Vec3D::new(),
    }
  }

  /// Try to find overlapping beacons between this and another scanner.
  pub fn try_merge(&mut self, other: &mut Scanner) {
    for _ in 0..ORIENTATIONS {
      let mut relative_pos: HashMap<Vec3D, usize> = HashMap::new();
      for beacon in self.beacons.iter() {
        for other_beacon in other.beacons.iter() {
          let mut pos = Vec3D::new();
          pos.x = beacon.x - other_beacon.x;
          pos.y = beacon.y - other_beacon.y;
          pos.z = beacon.z - other_beacon.z;
          *relative_pos.entry(pos).or_default() += 1;
        }
      }

      let matching_beacons =
        relative_pos.iter().max_by_key(|elem| elem.1).unwrap();
      if *matching_beacons.1 >= BEACON_THRESHOLD {
        for other_beacon in other.beacons.iter() {
          let mut pos = Vec3D::new();
          pos.x = matching_beacons.0.x + other_beacon.x;
          pos.y = matching_beacons.0.y + other_beacon.y;
          pos.z = matching_beacons.0.z + other_beacon.z;

          if !self.beacons.contains(&pos) {
            self.beacons.push(pos);
          }
        }
        other.merged = true;
        other.position = *matching_beacons.0;
        return;
      }

      // Change orientation of the other scanner (by rotating the beacons)
      other.beacons.iter_mut().for_each(|b| b.rotate());
    }
  }

  /// Amount of beacons.
  pub fn count(&self) -> usize {
    self.beacons.len()
  }
}

impl From<String> for Scanner {
  /// Create a scanner from a string.
  fn from(string: String) -> Scanner {
    let mut scan: Scanner = Scanner::new();
    for line in string.lines() {
      scan.beacons.push(Vec3D::from(line.to_string()));
    }
    scan
  }
}
