mod day_06_lanternfish {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use lanternfish;

  /// Test of part 1 (18 steps).
  #[test]
  fn task_1_18() {
    assert_eq!(
      lanternfish::lanternfish(&INPUT_FILENAME.to_string(), &18),
      26
    );
  }

  /// Test of part 1 (80 steps).
  #[test]
  fn task_1_80() {
    assert_eq!(
      lanternfish::lanternfish(&INPUT_FILENAME.to_string(), &80),
      5934
    );
  }

  /// Test of part 2 (256 steps).
  #[test]
  fn task_2_256() {
    assert_eq!(
      lanternfish::lanternfish(&INPUT_FILENAME.to_string(), &256),
      26984457539
    );
  }
}
