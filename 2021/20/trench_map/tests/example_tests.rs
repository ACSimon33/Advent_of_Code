mod day_20_rust_template {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use trench_map;

  /// Test of part 1 (1 step).
  #[test]
  fn task_1_1() {
    assert_eq!(
      trench_map::count_lit_pixels(&INPUT_FILENAME.to_string(), &1),
      24
    );
  }

  /// Test of part 1 (2 steps).
  #[test]
  fn task_1_2() {
    assert_eq!(
      trench_map::count_lit_pixels(&INPUT_FILENAME.to_string(), &2),
      35
    );
  }

  /// Test of part 2 (50 steps).
  #[test]
  fn task_2_50() {
    assert_eq!(
      trench_map::count_lit_pixels(&INPUT_FILENAME.to_string(), &50),
      3351
    );
  }
}
