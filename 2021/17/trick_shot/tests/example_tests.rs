mod day_17_trick_shot {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use trick_shot;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(trick_shot::heighest_shot(&INPUT_FILENAME.to_string()), 45);
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(
      trick_shot::distinct_velocities(&INPUT_FILENAME.to_string()),
      112
    );
  }
}
