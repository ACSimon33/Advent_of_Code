import * as fs from 'fs';

// ************************************************************************** //

// Section class
class Section {
  // Compartments
  private start: number;
  private end: number;

  // Constructor - Initialize compartments
  public constructor(str: string) {
    const ids: string[] = str.split('-');
    this.start = Number(ids[0]);
    this.end = Number(ids[1]);
  }

  // Check if this section contains another
  public contains(other: Section): boolean {
    return this.start <= other.start && this.end >= other.end;
  }

  // Check if this section overlaps with another
  public overlaps(other: Section): boolean {
    return (
      (this.start <= other.start && this.end >= other.start) ||
      (other.start <= this.start && other.end >= this.start)
    );
  }
}

// Count elements in a array that fulfill a given condition
function count<T>(arr: T[], predicate: (elem: T) => boolean): number {
  return arr.reduce((acc: number, cur: T) => {
    return acc + Number(predicate(cur));
  }, 0);
}

// ************************************************************************** //

/// First task.
export function count_contained_sections(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse sections
  const sections: Section[][] = lines.map((str: string) => {
    return str.split(',').map((section_str: string) => {
      return new Section(section_str);
    });
  });

  // Count number of section pairs that contain each other completely
  return count(sections, (sec: Section[]) => {
    return sec[0].contains(sec[1]) || sec[1].contains(sec[0]);
  });
}

/// Second task.
export function count_overlapping_sections(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse sections
  const sections: Section[][] = lines.map((str: string) => {
    return str.split(',').map((section_str: string) => {
      return new Section(section_str);
    });
  });

  // Count number of section pairs that overlap
  return count(sections, (sec: Section[]) => {
    return sec[0].overlaps(sec[1]);
  });
}
