mod day_21_dirac_dice {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use dirac_dice;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(
      dirac_dice::deterministic_die(&INPUT_FILENAME.to_string()),
      (745, 993)
    );
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(
      dirac_dice::quantum_die(&INPUT_FILENAME.to_string()),
      (444356092776315, 341960390180808)
    );
  }
}
