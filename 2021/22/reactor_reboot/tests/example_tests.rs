mod day_22_reactor_reboot {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use reactor_reboot;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(reactor_reboot::solution_1(&INPUT_FILENAME.to_string()), 0);
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(reactor_reboot::solution_2(&INPUT_FILENAME.to_string()), 1);
  }
}
