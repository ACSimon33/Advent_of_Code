use std::fs;

mod home;
use home::AmphipodHome;

/// Calculate the least amount of energy needed to move every amphipod in their
/// corresponding room.
pub fn least_amount_of_energy(filename: &String) -> u32 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");

  // Initialize home
  let mut home = AmphipodHome::from(contents);
  let mut cheapest_solution: u32 = u32::MAX;

  simulate(&mut home, 0, &mut cheapest_solution);
  return cheapest_solution;
}

/// Simulates all possible move orders recursively and calculates the cheapest.
fn simulate(
  home: &mut AmphipodHome,
  current_price: u32,
  cheapest_solution: &mut u32,
) {
  let mut moves = home.calc_possible_moves();

  // if !home._validate() {
  //   dbg!(&home.moves);
  //   dbg!(&home.hallway);
  //   dbg!(&home.rooms);
  //   std::process::exit(1);
  // }

  // Check if the final position is reached.
  if moves.is_empty() && home.is_final_position() {
    *cheapest_solution = current_price;
  }

  // Make moves
  while !moves.is_empty() {
    let m = moves.pop().unwrap();
    let price = current_price + m.calculate_price();

    if price < *cheapest_solution {
      home.make_move(m);
      simulate(home, price, cheapest_solution);
      home.revert_move();
    }
  }
}
