mod day_18_snailfish {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME_1: &str = "input/example_input_1.txt";
  const INPUT_FILENAME_2: &str = "input/example_input_2.txt";
  const INPUT_FILENAME_3: &str = "input/example_input_3.txt";
  const INPUT_FILENAME_4: &str = "input/example_input_4.txt";
  const INPUT_FILENAME_5: &str = "input/example_input_5.txt";
  const INPUT_FILENAME_6: &str = "input/example_input_6.txt";
  const INPUT_FILENAME_7: &str = "input/example_input_7.txt";

  // Import puzzle solutions module
  use snailfish;

  /// Test of part 1 (input 1).
  #[test]
  fn task_1_1() {
    assert_eq!(
      snailfish::sum_of_all_numbers(&INPUT_FILENAME_1.to_string()),
      143
    );
  }

  /// Test of part 1 (input 2).
  #[test]
  fn task_1_2() {
    assert_eq!(
      snailfish::sum_of_all_numbers(&INPUT_FILENAME_2.to_string()),
      1384
    );
  }

  /// Test of part 1 (input 3).
  #[test]
  fn task_1_3() {
    assert_eq!(
      snailfish::sum_of_all_numbers(&INPUT_FILENAME_3.to_string()),
      445
    );
  }

  /// Test of part 1 (input 4).
  #[test]
  fn task_1_4() {
    assert_eq!(
      snailfish::sum_of_all_numbers(&INPUT_FILENAME_4.to_string()),
      791
    );
  }

  /// Test of part 1 (input 5).
  #[test]
  fn task_1_5() {
    assert_eq!(
      snailfish::sum_of_all_numbers(&INPUT_FILENAME_5.to_string()),
      1137
    );
  }

  /// Test of part 1 (input 6).
  #[test]
  fn task_1_6() {
    assert_eq!(
      snailfish::sum_of_all_numbers(&INPUT_FILENAME_6.to_string()),
      3488
    );
  }

  /// Test of part 1 (input 7).
  #[test]
  fn task_1_7() {
    assert_eq!(
      snailfish::sum_of_all_numbers(&INPUT_FILENAME_7.to_string()),
      4140
    );
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(snailfish::largest_sum(&INPUT_FILENAME_7.to_string()), 3993);
  }
}
