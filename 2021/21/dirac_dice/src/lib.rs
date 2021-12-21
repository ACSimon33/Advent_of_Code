use phf::phf_map;
use std::collections::HashMap;
use std::fs;

/// Amount points a player needs to win.
const WINNING_THRESHOLD: i32 = 21;

/// Possible rolls with their frequencies (for 3 rolls with a 3-sided die).
const UNIVERSE_FREQUENCIES: phf::Map<i32, u64> = phf_map! {
  3_i32 => 1,
  4_i32 => 3,
  5_i32 => 6,
  6_i32 => 7,
  7_i32 => 6,
  8_i32 => 3,
  9_i32 => 1,
};

/// Play the game with a determenistic die and return the amount of rolls
/// as well as the points of the losing player.
pub fn deterministic_die(filename: &String) -> (i32, i32) {
  let (mut player1, mut player2) = starting_positions(filename);

  let mut player1_points: i32 = 0;
  let mut player2_points: i32 = 0;
  let mut player1_turn: bool = true;

  let mut dice: i32 = 0;
  let mut rolls: i32 = 0;
  while player1_points < 1000 && player2_points < 1000 {
    let roll = match dice {
      98 => 200,
      99 => 103,
      _ => 3 * (dice + 2),
    };
    dice += 3;
    dice %= 100;

    if player1_turn {
      player1 = (player1 + roll) % 10;
      player1_points += player1 + 1;
    } else {
      player2 = (player2 + roll) % 10;
      player2_points += player2 + 1;
    }

    player1_turn = !player1_turn;
    rolls += 3;
  }

  if player1_turn {
    return (player1_points, rolls);
  } else {
    return (player2_points, rolls);
  }
}

/// Universe as a state tuple of the game.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
struct Universe {
  player1: i32,
  player2: i32,
  player1_points: i32,
  player2_points: i32,
  player1_turn: bool,
}

/// Multiverse which maps universes to their game results.
type Muliverse = HashMap<Universe, (u64, u64)>;

/// Play the game with a quantum die and return the amount universes each
/// player wins in.
pub fn quantum_die(filename: &String) -> (u64, u64) {
  let (player1, player2) = starting_positions(filename);

  // Keep track of possible universes
  let mut multiverse: Muliverse = Muliverse::new();
  let root_universe = Universe {
    player1: player1,
    player2: player2,
    player1_points: 0,
    player2_points: 0,
    player1_turn: true,
  };

  return process_universe(&mut multiverse, root_universe);
}

/// Play all possible universes recursively and count how many each player wins.
fn process_universe(
  multiverse: &mut Muliverse,
  universe: Universe,
) -> (u64, u64) {
  // Quick return if one of the players won
  if universe.player1_points >= WINNING_THRESHOLD {
    return (1, 0);
  } else if universe.player2_points >= WINNING_THRESHOLD {
    return (0, 1);
  }

  // Quick return if the universe was already visited
  if multiverse.contains_key(&universe) {
    return multiverse[&universe];
  }

  let mut wins: (u64, u64) = (0, 0);
  for (roll, &frequency) in UNIVERSE_FREQUENCIES.entries() {
    let mut new_universe = Universe {
      player1: universe.player1,
      player2: universe.player2,
      player1_points: universe.player1_points,
      player2_points: universe.player2_points,
      player1_turn: !universe.player1_turn,
    };

    if universe.player1_turn {
      new_universe.player1 = (new_universe.player1 + roll) % 10;
      new_universe.player1_points += new_universe.player1 + 1;
    } else {
      new_universe.player2 = (new_universe.player2 + roll) % 10;
      new_universe.player2_points += new_universe.player2 + 1;
    }

    let sub_wins = process_universe(multiverse, new_universe);
    wins.0 += frequency * sub_wins.0;
    wins.1 += frequency * sub_wins.1;
  }

  multiverse.insert(universe, wins);
  return wins;
}

/// Parse the starting positions of the players from the input.
pub fn starting_positions(filename: &String) -> (i32, i32) {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  let player1: i32 = lines[0]
    .split_once("Player 1 starting position: ")
    .unwrap()
    .1
    .parse::<i32>()
    .unwrap()
    - 1;
  let player2: i32 = lines[1]
    .split_once("Player 2 starting position: ")
    .unwrap()
    .1
    .parse::<i32>()
    .unwrap()
    - 1;

  return (player1, player2);
}
