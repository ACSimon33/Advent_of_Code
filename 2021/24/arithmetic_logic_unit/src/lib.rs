use std::fs;

mod alu;
use alu::ExitCode;
use alu::ALU;

/// Lenght of the model number.
const MODEL_NUMBER_LENGTH: usize = 14;

/// Degrees of freedom in the model number.
const FREE_POSITIONS: [usize; 7] = [0, 1, 2, 4, 5, 6, 8];

/// Factors in the MONAD algorithm (extracted by hand).
const FACTORS: ModelNumber =
  [10, 12, 15, -9, 15, 10, 14, -5, 14, -7, -12, -10, -1, -11];

/// Model number type.
type ModelNumber = [i64; MODEL_NUMBER_LENGTH];

/// Load a program and run it with a given input.
pub fn run_program_with_input(
  program_filename: &String,
  input_filename: &String,
) -> (i64, i64, i64, i64) {
  let program =
    fs::read_to_string(program_filename).expect("Couldn't read program file.");
  let inputs: Vec<i64> = fs::read_to_string(input_filename)
    .expect("Couldn't read program file.")
    .split(",")
    .map(|input| input.parse().unwrap())
    .collect();

  let mut cpu = ALU::new();
  cpu.load_program(program);
  let ec = cpu.run(&inputs);

  if ec != ExitCode::Success {
    panic!("Exit code is not zero!");
  }

  return (cpu.w, cpu.x, cpu.y, cpu.z);
}

/// Calculate the highest model number.
pub fn maximum_model_number(program_filename: &String) -> ModelNumber {
  let program =
    fs::read_to_string(program_filename).expect("Couldn't read program file.");

  let mut cpu = ALU::new();
  cpu.load_program(program);

  let mut model_number: ModelNumber = [9; MODEL_NUMBER_LENGTH];
  find_maximum_model_number(&mut cpu, &mut model_number, 0);
  model_number
}

/// Find the highest model number recursively.
fn find_maximum_model_number(
  cpu: &mut ALU,
  model_number: &mut ModelNumber,
  pos: usize,
) -> bool {
  // Check final model number
  if pos == MODEL_NUMBER_LENGTH {
    return check_model_number(cpu, model_number);
  }

  if FREE_POSITIONS.contains(&pos) {
    // Iterate free positions
    while model_number[pos] > 0 {
      if find_maximum_model_number(cpu, model_number, pos + 1) {
        return true;
      } else {
        model_number[pos] -= 1;
      }
    }
    model_number[pos] = 9;
    return false;
  } else {
    // Deduce non free positions
    deduce_digit(cpu, model_number, pos);
    if model_number[pos] < 1 || model_number[pos] > 9 {
      return false;
    } else {
      return find_maximum_model_number(cpu, model_number, pos + 1);
    }
  }
}

/// Calculate the lowest model number.
pub fn minimum_model_number(program_filename: &String) -> ModelNumber {
  let program =
    fs::read_to_string(program_filename).expect("Couldn't read program file.");

  let mut cpu = ALU::new();
  cpu.load_program(program);

  let mut model_number: ModelNumber = [1; MODEL_NUMBER_LENGTH];
  find_minimum_model_number(&mut cpu, &mut model_number, 0);
  model_number
}

/// Find the lowest model number recursively.
fn find_minimum_model_number(
  cpu: &mut ALU,
  model_number: &mut ModelNumber,
  pos: usize,
) -> bool {
  // Check final model number
  if pos == MODEL_NUMBER_LENGTH {
    return check_model_number(cpu, model_number);
  }

  if FREE_POSITIONS.contains(&pos) {
    // Iterate free positions
    while model_number[pos] < 10 {
      if find_minimum_model_number(cpu, model_number, pos + 1) {
        return true;
      } else {
        model_number[pos] += 1;
      }
    }
    model_number[pos] = 1;
    return false;
  } else {
    // Deduce non free positions
    deduce_digit(cpu, model_number, pos);
    if model_number[pos] < 1 || model_number[pos] > 9 {
      return false;
    } else {
      return find_minimum_model_number(cpu, model_number, pos + 1);
    }
  }
}

/// Deduce a digit at a non-free position.
fn deduce_digit(cpu: &mut ALU, model_number: &mut ModelNumber, pos: usize) {
  cpu.reset();
  cpu.run(&model_number[0..pos].to_vec());
  model_number[pos] = cpu.z % 26 + FACTORS[pos];
}

/// Check the final model number.
fn check_model_number(cpu: &mut ALU, model_number: &mut ModelNumber) -> bool {
  cpu.reset();
  cpu.run(&model_number.to_vec());
  return cpu.z == 0;
}
