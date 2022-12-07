import * as fs from 'fs';

// ************************************************************************** //

// File handle
interface File {
  _name: string;
  _size: number;
}

// Directory class
class Directory {
  private _name: string;
  private _children: (File | Directory)[];

  // Create an empty folder with a given name
  public constructor(name: string) {
    this._name = name;
    this._children = [];
  }

  // Parse the file tree from the shell output
  public parse_file_tree(content: string[], idx: number): number {
    let i: number;
    for (i = idx; i < content.length; i++) {
      // Check for directory
      const match_dir = content[i].match(/\$ cd (.*)/);
      if (match_dir) {
        // Go up
        if (match_dir[1] == '..') {
          return i;
        }

        // Create new directory
        let dir = new Directory(match_dir[1]);
        i = dir.parse_file_tree(content, i + 1);
        this._children.push(dir);
        continue;
      }

      // Check for file
      const match_file = content[i].match(/([0-9]+) (.*)/);
      if (match_file) {
        this._children.push({
          _name: match_file[2],
          _size: Number(match_file[1])
        });
      }
    }

    return i;
  }

  // Calculate the size of the directory
  public size(): number {
    let size: number = 0;
    for (const child of this._children) {
      if (child instanceof Directory) {
        size += child.size();
      } else {
        size += child._size;
      }
    }

    return size;
  }

  // Sum up the sizes of the directories below a certain size
  public sum_sizes_below(max_size: number): number {
    let cumulative_size: number = 0;
    let dir_size = this.size();
    if (dir_size <= max_size) {
      cumulative_size += dir_size;
    }

    for (const child of this._children) {
      if (child instanceof Directory) {
        cumulative_size += child.sum_sizes_below(max_size);
      }
    }

    return cumulative_size;
  }

  // Find the smalles directory that is still above a certain size
  public find_smallest_directory_above(min_size: number): Directory | null {
    let smallest_dir: Directory | null = null;

    if (this.size() >= min_size) {
      smallest_dir = this;
    }

    for (const child of this._children) {
      if (child instanceof Directory) {
        let tmp_dir = child.find_smallest_directory_above(min_size);
        if (tmp_dir) {
          if (smallest_dir) {
            if (!smallest_dir || tmp_dir.size() < smallest_dir.size()) {
              smallest_dir = tmp_dir;
            }
          }
        }
      }
    }

    return smallest_dir;
  }
}

// ************************************************************************** //

/// First task.
export function folders_below_100000(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  let root = new Directory('/');
  root.parse_file_tree(lines, 1);

  return root.sum_sizes_below(100000);
}

/// Second task.
export function find_folder_to_delete(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  let root = new Directory('/');
  root.parse_file_tree(lines, 1);

  const total_space: number = 70000000;
  const needed_space: number = 30000000;
  const free_space: number = total_space - root.size();

  return root.find_smallest_directory_above(needed_space - free_space)!.size();
}
