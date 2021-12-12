
#[derive(Clone, Debug)]
pub struct BingoBoard {
  pub board: Vec<i32>,
  pub checked: Vec<bool>
}

impl BingoBoard {
  pub fn grow_board(&mut self, line: &str) {
    self.board.extend(
      line.split_whitespace().map(|x| x.parse::<i32>().unwrap()));
  }

  pub fn validate_board(&mut self) {
    let fsqrt = (self.board.len() as f64).sqrt();
    let isqrt = fsqrt as i64;
    if fsqrt != (isqrt as f64) {
      panic!("Abort: Board is not square.");
    }
    self.checked.resize_with(self.board.len(), || false);
  }

  pub fn check_number(&mut self, num: &i32) -> bool {
    for (idx, board_num) in self.board.iter().enumerate() {
      if board_num == num {
        self.checked[idx] = true;
        return self.check_board(&idx);
      }
    }

    return false;
  }

  pub fn sum_of_unchecked(&self) -> i32 {
    let mut sum: i32 = 0;
    for (num, checked) in self.board.iter().zip(self.checked.iter()) {
      if !checked {
        sum += num;
      }
    }

    return sum;
  }

  fn check_board(&self, idx: &usize) -> bool {
    let side_len = (self.checked.len() as f64).sqrt() as usize;
    let row: usize = idx / side_len;
    let column: usize = idx % side_len;

    let column_full = self.checked.iter().enumerate()
      .filter(|(i, _)| i % side_len == column)
      .all(|(_, c)| *c);

    let row_full = self.checked.iter().enumerate()
      .filter(|(i, _)| i / side_len == row)
      .all(|(_, c)| *c);

    return column_full || row_full;
  }
}

pub fn empty_bingo_board() -> BingoBoard {
  BingoBoard {
    board: Vec::new(),
    checked: Vec::new()
  }
}