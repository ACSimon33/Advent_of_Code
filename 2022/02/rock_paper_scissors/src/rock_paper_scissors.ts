import * as fs from 'fs';

// Your choices
enum Opponent {
  A = 1,
  B = 2,
  C = 3,
};

// Opponents choices
enum You {
  X = 1,
  Y = 2,
  Z = 3,
};

interface MatchUp {
  _opponent: Opponent,
  _you: You
}

// Match matrix
const results: number[][] = [
  [3, 6, 0],
  [0, 3, 6],
  [6, 0, 3]
];

/// First task.
export function guess_instructioons(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  let score: number = 0;
  for (const line of lines) {
    let choices = line.split(' ');
    let match: MatchUp = {
      _opponent: Opponent[choices[0] as keyof typeof Opponent],
      _you: You[choices[1] as keyof typeof You]
    };

    score += match._you + results[match._opponent - 1][match._you - 1];
  }

  return score;
}

/// Second task.
export function follow_instructioons(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  let score: number = 0;
  for (const line of lines) {
    let choices = line.split(' ');
    let match: MatchUp = {
      _opponent: Opponent[choices[0] as keyof typeof Opponent],
      _you: You[choices[1] as keyof typeof You]
    };

    // Convert Lose, Draw, Win code into your choice
    match._you += match._opponent - Opponent.B;
    if (match._you > You.Z) {
      match._you -= You.Z;
    }
    if (match._you < You.X) {
      match._you += You.Z;
    }

    score += match._you + results[match._opponent - 1][match._you - 1];
  }

  return score;
}
