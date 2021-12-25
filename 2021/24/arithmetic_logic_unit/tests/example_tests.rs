mod day_24_arithmetic_logic_unit {
  use pretty_assertions::assert_eq;

  // Example input
  const PROGRAM_FILENAME_1: &str = "input/example_program_1.txt";
  const PROGRAM_FILENAME_2: &str = "input/example_program_2.txt";
  const PROGRAM_FILENAME_3: &str = "input/example_program_3.txt";
  const INPUT_FILENAME_1: &str = "input/example_input_1.txt";
  const INPUT_FILENAME_2A: &str = "input/example_input_2a.txt";
  const INPUT_FILENAME_2B: &str = "input/example_input_2b.txt";
  const INPUT_FILENAME_3: &str = "input/example_input_3.txt";

  // Import puzzle solutions module
  use arithmetic_logic_unit;

  /// Test of part 1 (program 1).
  #[test]
  fn task_1_1() {
    assert_eq!(
      arithmetic_logic_unit::run_program_with_input(
        &PROGRAM_FILENAME_1.to_string(),
        &INPUT_FILENAME_1.to_string()
      ),
      (0, -42, 0, 0)
    );
  }

  /// Test of part 1 (program 2).
  #[test]
  fn task_1_2a() {
    assert_eq!(
      arithmetic_logic_unit::run_program_with_input(
        &PROGRAM_FILENAME_2.to_string(),
        &INPUT_FILENAME_2A.to_string(),
      ),
      (0, 12, 0, 1)
    );
  }

  /// Test of part 1 (program 2).
  #[test]
  fn task_1_2b() {
    assert_eq!(
      arithmetic_logic_unit::run_program_with_input(
        &PROGRAM_FILENAME_2.to_string(),
        &INPUT_FILENAME_2B.to_string(),
      ),
      (0, 13, 0, 0)
    );
  }

  /// Test of part 1 (program 3).
  #[test]
  fn task_1_3() {
    assert_eq!(
      arithmetic_logic_unit::run_program_with_input(
        &PROGRAM_FILENAME_3.to_string(),
        &INPUT_FILENAME_3.to_string(),
      ),
      (1, 1, 0, 1)
    );
  }
}
