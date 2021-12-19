mod day_02_dive {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use dive;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(dive::distance_depth(&INPUT_FILENAME.to_string()), (15, 10));
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(
      dive::distance_depth_with_aim(&INPUT_FILENAME.to_string()),
      (15, 60)
    );
  }
}
