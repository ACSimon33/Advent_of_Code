use std::fs;

mod bingo_board;
use bingo_board::BingoBoard;

/// Return the score of the first winning board and the winning number.
pub fn first_winning_board(filename: &String) -> (i32, i32) {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");

  let lines: Vec<&str> = contents.lines().collect();
  let nums: Vec<i32> =
    lines[0].split(",").map(|x| x.parse().unwrap()).collect();

  let mut bingo_boards: Vec<BingoBoard> = Vec::new();
  for line in lines.iter().skip(1) {
    if line.is_empty() {
      bingo_boards.push(BingoBoard::new());
    } else {
      bingo_boards.last_mut().unwrap().grow_board(line);
    }
  }

  for board in bingo_boards.iter_mut() {
    board.validate_board();
  }

  let (board, last_num) = first_to_win(&mut bingo_boards, &nums);
  return (board.unwrap().sum_of_unchecked(), last_num);
}

/// Return the first winning board and the winning number.
fn first_to_win(
  boards: &mut Vec<BingoBoard>,
  nums: &Vec<i32>,
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

/// Return the score of the last winning board and the winning number.
pub fn last_winning_board(filename: &String) -> (i32, i32) {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");

  let lines: Vec<&str> = contents.lines().collect();
  let nums: Vec<i32> =
    lines[0].split(",").map(|x| x.parse().unwrap()).collect();

  let mut bingo_boards: Vec<BingoBoard> = Vec::new();
  for line in lines.iter().skip(1) {
    if line.is_empty() {
      bingo_boards.push(BingoBoard::new());
    } else {
      bingo_boards.last_mut().unwrap().grow_board(line);
    }
  }

  for board in bingo_boards.iter_mut() {
    board.validate_board();
  }

  let (board, last_num) = last_to_win(&mut bingo_boards, &nums);
  return (board.unwrap().sum_of_unchecked(), last_num);
}

/// Return the last winning board and the winning number.
fn last_to_win(
  boards: &mut Vec<BingoBoard>,
  nums: &Vec<i32>,
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

// Test example inputs against the reference solution
#[cfg(test)]
mod giant_squid_tests {
  use super::{first_winning_board, last_winning_board};
  const INPUT_FILENAME: &str = "input/example_input.txt";

  #[test]
  fn task_1() {
    assert_eq!(first_winning_board(&INPUT_FILENAME.to_string()), (188, 24));
  }

  #[test]
  fn task_2() {
    assert_eq!(last_winning_board(&INPUT_FILENAME.to_string()), (148, 13));
  }
}
