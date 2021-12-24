use regex::Regex;

/// Amount of amphipod species.
const AMOUNT_OF_SPECIES: usize = 4;

/// Lenght of the hallway.
const HALLWAY_LENGHT: usize = 11;

/// Positions in the hallways where amphipods can rest.
const WAITING_POS: [usize; 7] = [0, 1, 3, 5, 7, 9, 10];

/// Hallway positions in front of the rooms.
const ROOM_POS: [usize; AMOUNT_OF_SPECIES] = [2, 4, 6, 8];

/// The energy consumption per species.
const ENERGY_CONSUMPTION: [u32; AMOUNT_OF_SPECIES] = [1, 10, 100, 1000];

// Some helper types
type Hallway = [usize; HALLWAY_LENGHT];
type Room = Vec<usize>;
type Rooms = [Room; AMOUNT_OF_SPECIES];

/// Move struct which defines the move of single amphipod.
#[derive(Clone, Copy, Debug)]
pub struct Move {
  start: usize,
  end: usize,
  species: usize,
  steps: u32,
}

impl Move {
  /// Calculates the amount of energy needed for the move.
  pub fn calculate_price(&self) -> u32 {
    self.steps * ENERGY_CONSUMPTION[self.species]
  }
}

/// The entire home of the amphipods. Has different vectors and array for the
/// hallway and the rooms.
#[derive(Clone, Debug)]
pub struct AmphipodHome {
  pub hallway: Hallway,
  pub rooms: Rooms,
  pub room_size: usize,
  pub moves: Vec<Move>,
}

impl AmphipodHome {
  /// Creates a new empty amphipod home.
  pub fn new() -> AmphipodHome {
    AmphipodHome {
      hallway: [AMOUNT_OF_SPECIES; HALLWAY_LENGHT],
      rooms: [Vec::new(), Vec::new(), Vec::new(), Vec::new()],
      room_size: 0,
      moves: Vec::new(),
    }
  }

  /// Unique ID for a home for faster hashing in the cache.
  pub fn id(&self) -> u64 {
    let mut id: u64 = 0;
    id += self
      .hallway
      .iter()
      .enumerate()
      .map(|(idx, c)| (*c as u64) * 5_u64.pow(idx as u32))
      .sum::<u64>();
    for i in 0..AMOUNT_OF_SPECIES {
      id += self.rooms[i]
        .iter()
        .enumerate()
        .map(|(idx, c)| {
          (*c as u64)
            * 5_u64.pow((HALLWAY_LENGHT + i * self.room_size + idx) as u32)
        })
        .sum::<u64>();
    }
    id
  }

  /// Calculate all possible moves. If there is a move into a room, this move
  /// takes precedence over all others.
  pub fn calc_possible_moves(&self) -> Vec<Move> {
    let mut moves: Vec<Move> = Vec::new();

    // Look for moves into rooms ...
    for i in 0..AMOUNT_OF_SPECIES {
      if self.is_room_free(i) {
        // ... from the hallway
        for &pos in WAITING_POS.iter() {
          if self.hallway[pos] == i {
            if self.is_hallway_free(pos, ROOM_POS[i]) {
              let end = self.get_free_room_position(i);
              moves.push(Move {
                start: pos,
                end: end,
                species: i,
                steps: self.calculate_steps(pos, end),
              });
              return moves;
            }
          }
        }
        // ... from other rooms
        for i2 in (0..AMOUNT_OF_SPECIES).filter(|i2| *i2 != i) {
          let (start, amphipod) = self.get_top_amphipod(i2);
          if amphipod == i {
            if self.is_hallway_free(ROOM_POS[i2], ROOM_POS[i]) {
              let end = self.get_free_room_position(i);
              moves.push(Move {
                start: start,
                end: end,
                species: i,
                steps: self.calculate_steps(start, end),
              });
              return moves;
            }
          }
        }
      }
    }

    // Look for moves from rooms into the hallway
    for i in 0..AMOUNT_OF_SPECIES {
      if !self.is_room_free(i) && !self.is_room_full(i) {
        let (start, amphipod) = self.get_top_amphipod(i);
        for &pos in WAITING_POS.iter() {
          if self.is_hallway_free(ROOM_POS[i], pos) {
            moves.push(Move {
              start: start,
              end: pos,
              species: amphipod,
              steps: self.calculate_steps(start, pos),
            })
          }
        }
      }
    }

    return moves;
  }

  /// Moves an amphipod according to the move object.
  pub fn make_move(&mut self, m: Move) {
    if m.start < HALLWAY_LENGHT {
      let i = (m.end - HALLWAY_LENGHT) / self.room_size;
      let j = (m.end - HALLWAY_LENGHT) % self.room_size;
      self.hallway[m.start] = AMOUNT_OF_SPECIES;
      self.rooms[i][j] = m.species;
    } else if m.end < HALLWAY_LENGHT {
      let i = (m.start - HALLWAY_LENGHT) / self.room_size;
      let j = (m.start - HALLWAY_LENGHT) % self.room_size;
      self.rooms[i][j] = AMOUNT_OF_SPECIES;
      self.hallway[m.end] = m.species;
    } else {
      let i1 = (m.start - HALLWAY_LENGHT) / self.room_size;
      let j1 = (m.start - HALLWAY_LENGHT) % self.room_size;
      let i2 = (m.end - HALLWAY_LENGHT) / self.room_size;
      let j2 = (m.end - HALLWAY_LENGHT) % self.room_size;
      self.rooms[i1][j1] = AMOUNT_OF_SPECIES;
      self.rooms[i2][j2] = m.species;
    }

    self.moves.push(m);
  }

  /// Undoes the latest move.
  pub fn revert_move(&mut self) {
    let m = self.moves.pop().unwrap();
    if m.start < HALLWAY_LENGHT {
      let i = (m.end - HALLWAY_LENGHT) / self.room_size;
      let j = (m.end - HALLWAY_LENGHT) % self.room_size;
      self.hallway[m.start] = m.species;
      self.rooms[i][j] = AMOUNT_OF_SPECIES;
    } else if m.end < HALLWAY_LENGHT {
      let i = (m.start - HALLWAY_LENGHT) / self.room_size;
      let j = (m.start - HALLWAY_LENGHT) % self.room_size;
      self.rooms[i][j] = m.species;
      self.hallway[m.end] = AMOUNT_OF_SPECIES;
    } else {
      let i1 = (m.start - HALLWAY_LENGHT) / self.room_size;
      let j1 = (m.start - HALLWAY_LENGHT) % self.room_size;
      let i2 = (m.end - HALLWAY_LENGHT) / self.room_size;
      let j2 = (m.end - HALLWAY_LENGHT) % self.room_size;
      self.rooms[i1][j1] = m.species;
      self.rooms[i2][j2] = AMOUNT_OF_SPECIES;
    }
  }

  /// Checks if all amphipods are in their rooms.
  pub fn is_final_position(&self) -> bool {
    (0..AMOUNT_OF_SPECIES).all(|i| self.rooms[i].iter().all(|c| *c == i))
  }

  /// Check if non of the amphipods is missing (for debugging purposes).
  pub fn _validate(&self) -> bool {
    let mut count = 0;
    count += self
      .hallway
      .iter()
      .filter(|&c| *c != AMOUNT_OF_SPECIES)
      .count();
    for i in 0..AMOUNT_OF_SPECIES {
      count += self.rooms[i]
        .iter()
        .filter(|&c| *c != AMOUNT_OF_SPECIES)
        .count();
    }
    count == AMOUNT_OF_SPECIES * self.room_size
  }

  /// Check if a segment in the hallway is free.
  fn is_hallway_free(&self, start: usize, end: usize) -> bool {
    if start <= end {
      WAITING_POS
        .iter()
        .filter(|&p| *p > start && *p <= end)
        .all(|&p| self.hallway[p] == AMOUNT_OF_SPECIES)
    } else {
      WAITING_POS
        .iter()
        .filter(|&p| *p >= end && *p < start)
        .all(|&p| self.hallway[p] == AMOUNT_OF_SPECIES)
    }
  }

  /// Check if a room is ready for an amphipod to move in.
  fn is_room_free(&self, room_idx: usize) -> bool {
    self.rooms[room_idx]
      .iter()
      .all(|c| *c == AMOUNT_OF_SPECIES || *c == room_idx)
      && self.rooms[room_idx][0] == AMOUNT_OF_SPECIES
  }

  /// Check if a room is full (with the correct amphipods).
  fn is_room_full(&self, room_idx: usize) -> bool {
    self.rooms[room_idx].iter().all(|c| *c == room_idx)
  }

  /// Returns the next free position in the room.
  fn get_free_room_position(&self, room_idx: usize) -> usize {
    for j in (0..self.room_size).rev() {
      if self.rooms[room_idx][j] == AMOUNT_OF_SPECIES {
        return HALLWAY_LENGHT + room_idx * self.room_size + j;
      }
    }
    panic!("No free position in room!");
  }

  /// Returns the highest amphipod in the room as well as its position.
  fn get_top_amphipod(&self, room_idx: usize) -> (usize, usize) {
    for j in 0..self.room_size {
      if self.rooms[room_idx][j] != AMOUNT_OF_SPECIES {
        let idx = HALLWAY_LENGHT + room_idx * self.room_size + j;
        return (idx, self.rooms[room_idx][j]);
      }
    }
    return (usize::MAX, AMOUNT_OF_SPECIES);
  }

  /// Calculate the steps between two positions in the home.
  fn calculate_steps(&self, start: usize, end: usize) -> u32 {
    if start < HALLWAY_LENGHT {
      let i = (end - HALLWAY_LENGHT) / self.room_size;
      let j = (end - HALLWAY_LENGHT) % self.room_size;
      return self.hallway_distance(start, ROOM_POS[i]) + j as u32 + 1;
    } else if end < HALLWAY_LENGHT {
      let i = (start - HALLWAY_LENGHT) / self.room_size;
      let j = (start - HALLWAY_LENGHT) % self.room_size;
      return self.hallway_distance(ROOM_POS[i], end) + j as u32 + 1;
    } else {
      let i1 = (start - HALLWAY_LENGHT) / self.room_size;
      let j1 = (start - HALLWAY_LENGHT) % self.room_size;
      let i2 = (end - HALLWAY_LENGHT) / self.room_size;
      let j2 = (end - HALLWAY_LENGHT) % self.room_size;
      return self.hallway_distance(ROOM_POS[i1], ROOM_POS[i2])
        + (j1 + j2) as u32
        + 2;
    }
  }

  /// Calculate the length of a hallway segment.
  fn hallway_distance(&self, start: usize, end: usize) -> u32 {
    if start < end {
      (end - start) as u32
    } else {
      (start - end) as u32
    }
  }
}

impl From<String> for AmphipodHome {
  /// Create an amphipod home from a string.
  fn from(string: String) -> AmphipodHome {
    let mut home = AmphipodHome::new();

    let re =
      Regex::new(r"[ |#]*#(A|B|C|D)#(A|B|C|D)#(A|B|C|D)#(A|B|C|D)[ |#]*")
        .unwrap();

    for line in string.lines() {
      let cap_opt = re.captures(line);

      if cap_opt.is_some() {
        let cap = cap_opt.unwrap();
        if cap.len() == AMOUNT_OF_SPECIES + 1 {
          for i in 0..AMOUNT_OF_SPECIES {
            home.rooms[i].push(
              match cap.get(i + 1).unwrap().as_str().chars().nth(0).unwrap() {
                'A' => 0,
                'B' => 1,
                'C' => 2,
                'D' => 3,
                _ => panic!("Unknown amphipod!"),
              },
            );
          }
          home.room_size += 1;
        }
      }
    }

    home
  }
}
