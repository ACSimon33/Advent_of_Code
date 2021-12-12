use std::fs;
use std::env;

mod bingo_board;
use bingo_board::BingoBoard;
use bingo_board::empty_bingo_board;

fn main() {
  let args: Vec<String> = env::args().collect();
  let filename = &args[1];
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");

  let lines: Vec<&str> = contents.lines().collect();
  let nums: Vec<i32> = lines[0].split(",")
    .map(|x| x.parse().unwrap()).collect();

  let mut bingo_boards: Vec<BingoBoard> = Vec::new();
  for line in lines.iter().skip(1) {
    if line.is_empty() {
      bingo_boards.push(empty_bingo_board());
    } else {
      bingo_boards.last_mut().unwrap().grow_board(line);
    }
  }

  for board in bingo_boards.iter_mut() {
    board.validate_board();
  }

  let (first_winning_board, num_1) = first_to_win(&mut bingo_boards, &nums);
  let unchecked_sum_1 = first_winning_board.unwrap().sum_of_unchecked();
  println!("1. Sum of unchecked numbers on winning board: {}", unchecked_sum_1);
  println!("1. Winning number: {}", num_1);
  println!("1. Result: {}", unchecked_sum_1 * num_1);

  let (last_winning_board, num_2) = last_to_win(&mut bingo_boards, &nums);
  let unchecked_sum_2 = last_winning_board.unwrap().sum_of_unchecked();
  println!("2. Sum of unchecked numbers on winning board: {}", unchecked_sum_2);
  println!("2. Winning number: {}", num_2);
  println!("2. Result: {}", unchecked_sum_2 * num_2);
}

fn first_to_win(
  boards: &mut Vec<BingoBoard>, nums: &Vec<i32>
) -> (Option<BingoBoard>, i32) {
  for n in nums.iter() {
    for board in boards.iter_mut() {
      if board.check_number(n) {
        return (Some(board.clone()), *n);
      }
    }
  }

  return (None, -1);
}

fn last_to_win(
  boards: &mut Vec<BingoBoard>, nums: &Vec<i32>
) -> (Option<BingoBoard>, i32) {
  let mut won_boards = vec![false; boards.len()];
  for n in nums.iter() {
    for (i, board) in boards.iter_mut().enumerate() {
      if !won_boards[i] {
        won_boards[i] = board.check_number(n);

        if won_boards.iter().all(|x| *x) {
          return (Some(board.clone()), *n);
        }
      }
    }
  }

  return (None, -1);
}