mod day_22_reactor_reboot {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME_1: &str = "input/example_input_1.txt";
  const INPUT_FILENAME_2: &str = "input/example_input_2.txt";
  const INPUT_FILENAME_3: &str = "input/example_input_3.txt";
  const INPUT_FILENAME_4: &str = "input/example_input_4.txt";
  const INPUT_FILENAME_5: &str = "input/example_input_5.txt";
  const INPUT_FILENAME_6: &str = "input/example_input_6.txt";

  // Import puzzle solutions module
  use reactor_reboot;

  /// Test of part 1 (1 cuboid).
  #[test]
  fn task_1_1() {
    assert_eq!(
      reactor_reboot::count_cubes(&INPUT_FILENAME_1.to_string(), 50),
      27
    );
  }

  /// Test of part 1 (2 cuboid).
  #[test]
  fn task_1_2() {
    assert_eq!(
      reactor_reboot::count_cubes(&INPUT_FILENAME_2.to_string(), 50),
      46
    );
  }

  /// Test of part 1 (3 cuboid).
  #[test]
  fn task_1_3() {
    assert_eq!(
      reactor_reboot::count_cubes(&INPUT_FILENAME_3.to_string(), 50),
      38
    );
  }

  /// Test of part 1 (4 cuboid).
  #[test]
  fn task_1_4() {
    assert_eq!(
      reactor_reboot::count_cubes(&INPUT_FILENAME_4.to_string(), 50),
      39
    );
  }

  /// Test of part 1 (medium example).
  #[test]
  fn task_1_5() {
    assert_eq!(
      reactor_reboot::count_cubes(&INPUT_FILENAME_5.to_string(), 50),
      590784
    );
  }

  /// Test of part 1 (large example).
  #[test]
  fn task_1_6() {
    assert_eq!(
      reactor_reboot::count_cubes(&INPUT_FILENAME_6.to_string(), 50),
      474140
    );
  }

  /// Test of part 2 (full space).
  #[test]
  fn task_2() {
    assert_eq!(
      reactor_reboot::count_cubes(&INPUT_FILENAME_6.to_string(), 0),
      2758514936282235
    );
  }
}
