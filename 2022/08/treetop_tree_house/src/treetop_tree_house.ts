import * as fs from 'fs';

// Viewing direction
enum Direction {
  Top = 0,
  Left,
  Right,
  Bottom
}

// Grid of trees
class TreeGrid {
  private trees: number[][];

  // Parse tree grid
  public constructor(lines: string[]) {
    this.trees = [];

    for (const line of lines) {
      this.trees.push(
        line.split('').map((tree: string) => {
          return Number(tree);
        })
      );
    }
  }

  // Count visible trees
  public count_visible_trees(): number {
    let visible_trees: number =
      2 * this.trees.length + 2 * this.trees[0].length - 4;

    // Iterate over trees inside the gridd
    for (let i = 1; i < this.trees.length - 1; i++) {
      for (let j = 1; j < this.trees[i].length - 1; j++) {
        let visible: boolean[] = [true, true, true, true];

        // Iterate over top neighbours
        for (let k = j - 1; k >= 0; k--) {
          if (this.trees[i][k] >= this.trees[i][j]) {
            visible[Direction.Top] = false;
            break;
          }
        }

        // Iterate over bottom neighbours
        for (let k = j + 1; k < this.trees[i].length; k++) {
          if (this.trees[i][k] >= this.trees[i][j]) {
            visible[Direction.Bottom] = false;
            break;
          }
        }

        // Iterate over left neighbours
        for (let k = i - 1; k >= 0; k--) {
          if (this.trees[k][j] >= this.trees[i][j]) {
            visible[Direction.Left] = false;
            break;
          }
        }

        // Iterate over right neighbours
        for (let k = i + 1; k < this.trees.length; k++) {
          if (this.trees[k][j] >= this.trees[i][j]) {
            visible[Direction.Right] = false;
            break;
          }
        }

        if (visible.some((element: boolean) => element)) {
          visible_trees++;
        }
      }
    }

    return visible_trees;
  }

  // For each tree calculate the number of trees, that are visible in each
  // direction and multiply those values together
  public calculate_max_scenic_score(): number {
    let max_scenic_score: number = 0;

    // Iterate over inner trees
    for (let i = 1; i < this.trees.length - 1; i++) {
      for (let j = 1; j < this.trees[i].length - 1; j++) {
        let visible_trees: number[] = [0, 0, 0, 0];

        // Iterate over top neighbours
        for (let k = j - 1; k >= 0; k--) {
          visible_trees[Direction.Top]++;
          if (this.trees[i][k] >= this.trees[i][j]) {
            break;
          }
        }

        // Iterate over bottom neighbours
        for (let k = j + 1; k < this.trees[i].length; k++) {
          visible_trees[Direction.Bottom]++;
          if (this.trees[i][k] >= this.trees[i][j]) {
            break;
          }
        }

        // Iterate over left neighbours
        for (let k = i - 1; k >= 0; k--) {
          visible_trees[Direction.Left]++;
          if (this.trees[k][j] >= this.trees[i][j]) {
            break;
          }
        }

        // Iterate over right neighbours
        for (let k = i + 1; k < this.trees.length; k++) {
          visible_trees[Direction.Right]++;
          if (this.trees[k][j] >= this.trees[i][j]) {
            break;
          }
        }

        // Check if scenic score of current tree is higher
        max_scenic_score = Math.max(
          max_scenic_score,
          visible_trees.reduce((scenic_score: number, tree: number) => {
            return (scenic_score *= tree);
          }, 1)
        );
      }
    }

    return max_scenic_score;
  }
}

/// First task.
export function number_of_visible_trees(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  return new TreeGrid(lines).count_visible_trees();
}

/// Second task.
export function max_scenic_score(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  return new TreeGrid(lines).calculate_max_scenic_score();
}
