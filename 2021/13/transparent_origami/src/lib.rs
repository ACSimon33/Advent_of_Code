use std::fs;

mod origami;
use origami::Fold;
use origami::Point;
use origami::Sheet;

/// Perform first fold.
pub fn first_fold(filename: &String) -> usize {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();
  let (mut sheet, folds) = parse(&lines);

  sheet.fold(&folds[0]);
  return sheet.count_points();
}

/// Generate code.
pub fn gen_code(filename: &String) -> String {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();
  let (mut sheet, folds) = parse(&lines);

  sheet.fold_all(&folds);
  return sheet.to_string();
}

/// Parse input.
fn parse(lines: &Vec<&str>) -> (Sheet, Vec<Fold>) {
  // Parse points
  let points: Vec<Point> = lines
    .iter()
    .filter(|line| line.split(",").count() == 2)
    .map(|line| {
      Point::new(
        line.split(",").nth(0).unwrap().parse().unwrap(),
        line.split(",").nth(1).unwrap().parse().unwrap(),
      )
    })
    .collect();

  // Parse fold instructions
  let folds: Vec<Fold> = lines
    .iter()
    .filter(|line| line.split("fold along ").count() == 2)
    .map(|line| line.split("fold along ").nth(1).unwrap())
    .map(|line| {
      Fold::new(
        line.split("=").nth(1).unwrap().parse().unwrap(),
        line.split("=").nth(0).unwrap(),
      )
    })
    .collect();

  return (Sheet::new(points), folds);
}
