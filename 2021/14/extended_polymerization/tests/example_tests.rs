mod day_14_extended_polymerization {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use extended_polymerization;

  /// Test of part 1 (5 steps).
  #[test]
  fn task_1_step_5() {
    let occurences =
      extended_polymerization::get_elements(&INPUT_FILENAME.to_string(), &5);
    assert_eq!(occurences.values().sum::<i64>(), 97);
  }

  /// Test of part 1 (10 steps).
  #[test]
  fn task_1_step_10() {
    let occurences =
      extended_polymerization::get_elements(&INPUT_FILENAME.to_string(), &10);
    assert_eq!(occurences.values().sum::<i64>(), 3073);
    assert_eq!(occurences[&'B'], 1749);
    assert_eq!(occurences[&'C'], 298);
    assert_eq!(occurences[&'H'], 161);
    assert_eq!(occurences[&'N'], 865);
  }

  /// Test of part 2 (40 steps).
  #[test]
  fn task_2_step_40() {
    let occurences =
      extended_polymerization::get_elements(&INPUT_FILENAME.to_string(), &40);
    assert_eq!(occurences[&'B'], 2192039569602);
    assert_eq!(occurences[&'H'], 3849876073);
  }
}
