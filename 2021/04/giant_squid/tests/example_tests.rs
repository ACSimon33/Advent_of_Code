mod day_04_giant_squid {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use giant_squid;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(
      giant_squid::first_winning_board(&INPUT_FILENAME.to_string()),
      (188, 24)
    );
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(
      giant_squid::last_winning_board(&INPUT_FILENAME.to_string()),
      (148, 13)
    );
  }
}
