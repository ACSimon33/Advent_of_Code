import * as fs from 'fs';

// ************************************************************************** //

// CRT display
class CRT {
  private _width: number;
  private _height: number;
  private _buffer: boolean[];
  private _idx: number;

  // Create display with given width and height
  public constructor(width: number, height: number) {
    this._width = width;
    this._height = height;
    this._buffer = new Array(this._width * this._height);
    this._idx = 0;
  }

  // Draw a single pixel at the current index
  public draw_pixel(sprite_pos: number) {
    const pixel_pos = this._idx % this._width;
    this._buffer[this._idx++] =
      pixel_pos >= sprite_pos - 1 && pixel_pos <= sprite_pos + 1;
  }

  // Convert the display buffer to a string output
  public get_display(): string {
    let disp: string = '';
    for (let i: number = 0; i < this._buffer.length; i++) {
      if (i > 0 && i % this._width == 0) {
        disp += '\n';
      }
      disp += this._buffer[i] ? '#' : '.';
    }
    return disp;
  }
}

// CPU to parse the OP codes
class CPU {
  private _register_x: number;
  private _cycle: number;
  private _signal_strength: number;
  private _crt?: CRT;

  // Create a CPU and optionally couple it with a CRT display
  public constructor(crt?: CRT) {
    this._register_x = 1;
    this._cycle = 0;
    this._signal_strength = 0;
    this._crt = crt;
  }

  // Perform a single instruction
  public perform_instruction(instruction: string) {
    this.run();

    const matches = instruction.match(/addx (-?[0-9]+)/);
    if (matches) {
      this.run();
      this._register_x += Number(matches[1]);
    }
  }

  // Return the signal strength
  public get_signal_strength(): number {
    return this._signal_strength;
  }

  // Run a single cycle and optionally draw a pixel on the CRT
  private run(): void {
    if ((++this._cycle - 20) % 40 == 0) {
      this._signal_strength += this._cycle * this._register_x;
    }
    this._crt?.draw_pixel(this._register_x);
  }
}

// ************************************************************************** //

/// First task.
export function signal_strength(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Create a standalone CPU and parse the instructions
  let cpu: CPU = new CPU();
  for (const line of lines) {
    cpu.perform_instruction(line);
  }

  // Return signal strength
  return cpu.get_signal_strength();
}

/// Second task.
export function display_output(filename: string): string {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Create a CPU coupled to a CRT display and parse the instructions
  let crt: CRT = new CRT(40, 6);
  let cpu: CPU = new CPU(crt);
  for (const line of lines) {
    cpu.perform_instruction(line);
  }

  // Return the CRT display output
  return crt.get_display();
}
