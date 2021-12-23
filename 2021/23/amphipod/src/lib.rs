use regex::Regex;
use std::fs;

const AMOUNT_OF_ROOMS: usize = 4;
const SPACE_PER_ROOM: usize = 2;
const HALLWAY_LENGHT: usize = 11;
const WAITING_POSITIONS: [usize; 7] = [0, 1, 3, 5, 7, 9, 10];

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum Rooms {
  A = 0,
  B = 1,
  C = 2,
  D = 3,
}

/// First task.
pub fn solution_1(filename: &String) -> i32 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  let mut rooms: [[char; SPACE_PER_ROOM]; AMOUNT_OF_ROOMS] =
    [['0'; SPACE_PER_ROOM]; AMOUNT_OF_ROOMS];

  let re = Regex::new(r"[ |#]*#(A|B|C|D)#(A|B|C|D)#(A|B|C|D)#(A|B|C|D)[ |#]*")
    .unwrap();
  for i in 0..SPACE_PER_ROOM {
    let cap = re.captures(lines[i + 2]).unwrap();
    for j in 0..AMOUNT_OF_ROOMS {
      rooms[j][i] = cap.get(j + 1).unwrap().as_str().chars().nth(0).unwrap();
    }
  }

  dbg!(&rooms);

  return 1;
}

/// Second task.
pub fn solution_2(filename: &String) -> i32 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let _lines: Vec<&str> = contents.lines().collect();

  return 1;
}
