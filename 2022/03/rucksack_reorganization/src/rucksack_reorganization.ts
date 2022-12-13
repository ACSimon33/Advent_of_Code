import * as fs from 'fs';

// ************************************************************************** //

// Create intersection of the two arrays
function find_matches(arr1: number[], arr2: number[]): number[] {
  return arr1.filter((value: number) => {
    return arr2.includes(value);
  });
}

// Rucksack class
class Rucksack {
  // Compartments
  private first_compartment: number[];
  private second_compartment: number[];

  // Constructor - Initialize compartments
  public constructor(content: string) {
    let size: number = content.length / 2;
    this.first_compartment = this.to_prio(content.substring(0, size));
    this.second_compartment = this.to_prio(content.substring(size));
  }

  // Find the item which is in both compartments
  public find_duplicate_item(): number {
    return find_matches(this.first_compartment, this.second_compartment)[0];
  }

  // Find the items which are in both Rucksacks
  public compare(other: Rucksack): number[] {
    return find_matches(
      [...new Set(this.first_compartment.concat(this.second_compartment))],
      [...new Set(other.first_compartment.concat(other.second_compartment))]
    );
  }

  // Char array to priority number array
  private to_prio(str: string): number[] {
    return str.split('').map((c: string) => {
      const ascii = c.charCodeAt(0);
      if (ascii >= 97) {
        return ascii - 96; // lowecase letters
      } else {
        return ascii - 38; // uppercase letters
      }
    });
  }
}

// ************************************************************************** //

/// First task.
export function sum_of_priorities(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Convert into Rucksacks
  const rucksacks: Rucksack[] = lines.map((str: string) => {
    return new Rucksack(str);
  });

  // Return sum of priorities
  return rucksacks
    .map((r: Rucksack) => {
      return r.find_duplicate_item();
    })
    .reduce((acc, cur) => {
      return acc + cur;
    }, 0);
}

/// Second task.
export function sum_of_badges(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Convert into Rucksacks
  const rucksacks: Rucksack[] = lines.map((str: string) => {
    return new Rucksack(str);
  });

  // Find badge in each group and sum up their priorities
  let sum_of_badges = 0;
  for (let i = 0; i < rucksacks.length; i += 3) {
    sum_of_badges += find_matches(
      rucksacks[i].compare(rucksacks[i + 1]),
      rucksacks[i + 1].compare(rucksacks[i + 2])
    )[0];
  }

  return sum_of_badges;
}
