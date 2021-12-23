use std::collections::HashMap;

/// Cave struct.
#[derive(Clone, Debug)]
pub struct Cave {
  pub is_big: bool,
  pub visited: usize,
}

impl Cave {
  /// Create a new big or small cave.
  pub fn new(big: bool) -> Cave {
    Cave { is_big: big, visited: 0 }
  }

  /// Visit cave.
  pub fn visit(
    &mut self,
    max_visits: &usize,
    looped: &mut bool,
    is_start: bool,
  ) -> bool {
    if self.is_big || self.visited == 0 {
      self.visited += 1;
      return true;
    } else if !is_start {
      if !*looped && self.visited < *max_visits {
        self.visited += 1;
        *looped = true;
        return true;
      } else if *looped && self.visited > 1 && self.visited < *max_visits {
        self.visited += 1;
        return true;
      }
    }
    return false;
  }

  /// Leave cave.
  pub fn leave(&mut self, looped: &mut bool) {
    if self.is_big || self.visited == 1 {
      self.visited -= 1;
    } else if *looped {
      self.visited -= 1;
      if self.visited == 1 {
        *looped = false;
      }
    } else {
      panic!("Something went wrong!");
    }
  }
}

/// Cave system as a Graph of caves and connections between them.
#[derive(Clone, Debug)]
pub struct CaveSystem {
  pub caves: HashMap<String, Cave>,
  pub connections: HashMap<String, Vec<String>>,
}

impl CaveSystem {
  /// Create an emtpy cave system.
  pub fn new() -> CaveSystem {
    CaveSystem { caves: HashMap::new(), connections: HashMap::new() }
  }

  /// Add a new connection between caves.
  pub fn add_connection(&mut self, connection: &str) {
    let cvs: Vec<&str> = connection.split("-").collect();
    if cvs.len() != 2 {
      panic!("Error: Connection doesn't contain 2 caves.");
    }

    // Create caves if necessary
    for s in cvs.iter() {
      if !self.caves.contains_key(&s.to_string()) {
        let cave =
          Cave::new(s.chars().all(|c| c.is_ascii_uppercase()) || *s == "end");
        self.caves.insert(s.to_string(), cave);
        self.connections.insert(s.to_string(), Vec::new());
      }
    }

    // Connect caves
    for c1 in cvs.iter() {
      for c2 in cvs.iter().filter(|c2| c1 != *c2) {
        self
          .connections
          .get_mut(&c1.to_string())
          .unwrap()
          .push(c2.to_string());
      }
    }
  }

  /// Traverse the cave system.
  pub fn traverse(&mut self, id: &String, mv: &usize, looped: &mut bool) {
    if self
      .caves
      .get_mut(id)
      .unwrap()
      .visit(mv, looped, id == "start")
    {
      if id != "end" {
        let connect = self.connections[id].clone();
        for cave_id in connect.iter() {
          self.traverse(cave_id, mv, looped);
        }
        self.caves.get_mut(id).unwrap().leave(looped);
      }
    }
  }
}
