mod day_05_hydrothermal_venture {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use hydrothermal_venture;

  /// Test of part 1.
  #[test]
  fn task_1() {
    let staight_lines = true;
    let cloud = hydrothermal_venture::vent_point_cloud(
      &INPUT_FILENAME.to_string(),
      staight_lines,
    );
    assert_eq!(cloud.iter().filter(|(_, &i)| i > 1).count(), 5);
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    let staight_lines = false;
    let cloud = hydrothermal_venture::vent_point_cloud(
      &INPUT_FILENAME.to_string(),
      staight_lines,
    );
    assert_eq!(cloud.iter().filter(|(_, &i)| i > 1).count(), 12);
  }
}
