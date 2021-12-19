mod day_14_transparent_origami {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use transparent_origami;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(
      transparent_origami::first_fold(&INPUT_FILENAME.to_string()),
      17
    );
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(
      transparent_origami::gen_code(&INPUT_FILENAME.to_string()),
      "#####\n#...#\n#...#\n#...#\n#####\n"
    );
  }
}
