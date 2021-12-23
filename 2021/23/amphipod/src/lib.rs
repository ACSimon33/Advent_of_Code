use regex::Regex;
use std::collections::VecDeque;
use std::fs;

const AMOUNT_OF_SPECIES: usize = 4;
const HALLWAY_LENGHT: usize = 11;
const WAITING_POSITIONS: [usize; 7] = [0, 1, 3, 5, 7, 9, 10];

/// Possible rolls with their frequencies (for 3 rolls with a 3-sided die).
const SPECIES: [char; AMOUNT_OF_SPECIES] = ['A', 'B', 'C', 'D'];
const ENERGY_CONSUMPTION: [u32; AMOUNT_OF_SPECIES] = [1, 10, 100, 1000];

#[derive(Clone, Copy, Debug)]
struct Move {
  start: usize,
  end: usize,
  species: usize,
}

impl Move {
  fn calculate_price(&self) -> u32 {
    let steps: u32;
    if self.start < self.end {
      let room_idx = 2 * (self.start / 2 + 5);
      if room_idx < self.end {
        steps = (self.end - room_idx + self.start % 2 + 1) as u32
      } else {
        steps = (room_idx - self.end + self.start % 2 + 1) as u32
      }
    } else {
      let room_idx = 2 * (self.end / 2 + 5);
      if room_idx < self.start {
        steps = (self.start - room_idx + self.end % 2 + 1) as u32
      } else {
        steps = (room_idx - self.start + self.end % 2 + 1) as u32
      }
    }

    steps * ENERGY_CONSUMPTION[self.species]
  }
}

/// First task.
pub fn solution_1(filename: &String) -> u32 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();
  let re = Regex::new(r"[ |#]*#(A|B|C|D)#(A|B|C|D)#(A|B|C|D)#(A|B|C|D)[ |#]*")
    .unwrap();

  let mut buffer: Vec<char> = vec!['\0'; HALLWAY_LENGHT];
  let mut cheapest_solution: u32 = u32::MAX;
  
  for line in lines.iter() {
    let cap = re.captures(line).unwrap();
    if cap.len() == AMOUNT_OF_SPECIES + 1 {
      for i in 0..AMOUNT_OF_SPECIES {
        buffer.push(
          cap.get(i + 1).unwrap().as_str().chars().nth(0).unwrap());
      }
    }
  }
    
  simulate(&mut buffer, 0, &mut cheapest_solution);

  return cheapest_solution;
}

fn simulate(
  buffer: &mut Vec<char>,
  current_price: u32,
  cheapest_solution: &mut u32,
) {
  let mut moves = calc_possible_moves(buffer);

  // Check if the game is finished  
  if moves.is_empty() {
    let mut final_position = true;
    for (room_idx, &amphipod) in SPECIES.iter().enumerate() {
      for j in 0..SPACE_PER_ROOM {
        if buffer[room_idx * SPACE_PER_ROOM + j] != amphipod {
          final_position = false;
          break;
        }
      }
      if !final_position {
        break;
      }
    }

    if final_position {
      *cheapest_solution = current_price;
    }
  }

  // Make moves
  while !moves.is_empty() {
    let m = moves.pop_front().unwrap();
    let price = current_price + m.calculate_price();

    // if current_price == 240 && buffer[11] == 'B' && buffer[13] == 'C' {
    //   // dbg!(&m);
    //   // dbg!(&price);
    // }

    if price < *cheapest_solution {
      buffer[m.start] = '\0';
      buffer[m.end] = SPECIES[m.species];
      simulate(buffer, price, cheapest_solution);
      buffer[m.start] = SPECIES[m.species];
      buffer[m.end] = '\0';
    }
  }
}

fn calc_possible_moves(buffer: &Buffer) -> VecDeque<Move> {
  let mut moves: VecDeque<Move> = VecDeque::new();

  // Look for moves from rooms into the hallway
  for i in 0..AMOUNT_OF_ROOMS {
    for j in 0..SPACE_PER_ROOM {
      if buffer[i * SPACE_PER_ROOM + j] != '\0' {
        let mut can_move: bool = false;
        let mut spec: char = '\0';
        for (room_idx, &amphipod) in SPECIES.iter().enumerate() {
          if buffer[i * SPACE_PER_ROOM + j] == amphipod {
            if i == room_idx {
              can_move = j == 0 && buffer[i * SPACE_PER_ROOM + 1] != amphipod;
            } else {
              can_move = j == 0 || buffer[i * SPACE_PER_ROOM] == '\0';
            }
            spec = amphipod;
            break;
          }
        }

        if can_move {
          // To the left
          for &pos in
            WAITING_POSITIONS.iter().filter(|&p| *p < 2 * (i + 5)).rev()
          {
            if buffer[pos] == '\0' {
              moves.push_back(Move {
                start: i * SPACE_PER_ROOM + j,
                end: pos,
                species: get_species(spec),
              })
            } else {
              break;
            }
          }

          // To the right
          for &pos in WAITING_POSITIONS.iter().filter(|&p| *p > 2 * (i + 5)) {
            if buffer[pos] == '\0' {
              moves.push_back(Move {
                start: i * SPACE_PER_ROOM + j,
                end: pos,
                species: get_species(spec),
              })
            } else {
              break;
            }
          }
        }
      }
    }
  }

  // Look for moves from the hallway into rooms
  for &pos in WAITING_POSITIONS.iter() {
    if buffer[pos] != '\0' {
      for (i, &amphipod) in SPECIES.iter().enumerate() {
        if buffer[pos] == amphipod {
          if clear_way(buffer, pos, i) && buffer[i * SPACE_PER_ROOM] == '\0' {
            if buffer[i * SPACE_PER_ROOM + 1] == '\0' {
              moves.push_front(Move {
                start: pos,
                end: i * SPACE_PER_ROOM + 1,
                species: get_species(amphipod),
              });
              break;
            } else if buffer[i * SPACE_PER_ROOM + 1] == amphipod {
              moves.push_front(Move {
                start: pos,
                end: i * SPACE_PER_ROOM,
                species: get_species(amphipod),
              });
              break;
            }
          }
        }
      }
    }
  }

  moves
}

fn clear_way(buffer: &Buffer, pos: usize, room: usize) -> bool {
  let room_idx = 2 * (room + 5);
  if room_idx < pos {
    WAITING_POSITIONS
      .iter()
      .filter(|&p| *p > room_idx && *p < pos)
      .all(|&p| buffer[p] == '\0')
  } else {
    WAITING_POSITIONS
      .iter()
      .filter(|&p| *p < room_idx && *p > pos)
      .all(|&p| buffer[p] == '\0')
  }
}

fn get_species(spec: char) -> usize {
  match spec {
    'A' => 0,
    'B' => 1,
    'C' => 2,
    'D' => 3,
    _ => panic!("Unknown species!"),
  }
}

/// Second task.
pub fn solution_2(filename: &String) -> i32 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let _lines: Vec<&str> = contents.lines().collect();

  return 1;
}
