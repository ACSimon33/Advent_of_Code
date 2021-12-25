/// Instruction types.
#[derive(Clone, Copy, Debug, PartialEq)]
enum InstructionID {
  Inp,
  Add,
  Mul,
  Div,
  Mod,
  Eql,
}

/// Instruction struct which defines an instruction with its operands.
#[derive(Clone, Debug, PartialEq)]
pub struct Instruction {
  id: InstructionID,
  operand_1: String,
  operand_2: String,
}

impl From<&str> for Instruction {
  /// Parse an instruction from a string.
  fn from(str: &str) -> Instruction {
    let parts: Vec<&str> = str.split_whitespace().collect();
    let id = match parts[0] {
      "inp" => InstructionID::Inp,
      "add" => InstructionID::Add,
      "mul" => InstructionID::Mul,
      "div" => InstructionID::Div,
      "mod" => InstructionID::Mod,
      "eql" => InstructionID::Eql,
      _ => panic!("Unknown instruction!"),
    };

    Instruction {
      id: id,
      operand_1: parts[1].to_string(),
      operand_2: {
        if id != InstructionID::Inp {
          parts[2].to_string()
        } else {
          String::new()
        }
      },
    }
  }
}

/// Exit codes.
#[derive(Clone, Copy, Debug, PartialEq)]
pub enum ExitCode {
  Success = 0,
  NotEnoughInputs = 1,
}

/// The algorithmic logic unit with 5 registers (one temporary) and a list
/// of instuctions.
#[derive(Clone, Debug)]
pub struct ALU {
  pub w: i64,
  pub x: i64,
  pub y: i64,
  pub z: i64,
  pub tmp: i64,
  pub instructions: Vec<Instruction>,
}

impl ALU {
  /// Creates a new empty ALU.
  pub fn new() -> ALU {
    ALU { x: 0, w: 0, y: 0, z: 0, tmp: 0, instructions: Vec::new() }
  }

  /// Load a new program.
  pub fn load_program(&mut self, string: String) {
    self.instructions.clear();
    for str in string.lines() {
      self.instructions.push(Instruction::from(str));
    }
  }

  /// Reset registers.
  pub fn reset(&mut self) {
    self.w = 0;
    self.x = 0;
    self.y = 0;
    self.z = 0;
    self.tmp = 0;
  }

  /// Run the loaded program.
  pub fn run(&mut self, inputs: &Vec<i64>) -> ExitCode {
    let mut input_idx: usize = 0;
    let instructions = self.instructions.clone();
    for ins in instructions.iter() {
      match ins.id {
        InstructionID::Inp => {
          if input_idx < inputs.len() {
            *self.register(&ins.operand_1) = inputs[input_idx];
            input_idx += 1;
          } else {
            return ExitCode::NotEnoughInputs;
          }
        }
        InstructionID::Add => {
          *self.register(&ins.operand_1) += *self.register(&ins.operand_2);
        }
        InstructionID::Mul => {
          *self.register(&ins.operand_1) *= *self.register(&ins.operand_2);
        }
        InstructionID::Div => {
          *self.register(&ins.operand_1) /= *self.register(&ins.operand_2);
        }
        InstructionID::Mod => {
          *self.register(&ins.operand_1) %= *self.register(&ins.operand_2);
        }
        InstructionID::Eql => {
          *self.register(&ins.operand_1) = (*self.register(&ins.operand_1)
            == *self.register(&ins.operand_2))
            as i64;
        }
      }
    }

    return ExitCode::Success;
  }

  /// Return a reference to a register.
  fn register(&mut self, operand: &String) -> &mut i64 {
    match operand.as_str() {
      "w" => &mut self.w,
      "x" => &mut self.x,
      "y" => &mut self.y,
      "z" => &mut self.z,
      _ => {
        self.tmp = operand.parse().unwrap();
        &mut self.tmp
      }
    }
  }
}
