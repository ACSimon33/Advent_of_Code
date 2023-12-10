package aoc2023.day10.pipeMaze

import java.util.LinkedList
import java.util.Queue

/** Region of the maze defined by a set of position IDs. */
typealias Region = MutableSet<Int>

/** Pipe Maze Solver */
public class PipeMaze(input: String) {
    private var maze = Maze(input)

    /** First task: Count the pipe segments in the loop and return the half way point. */
    fun furthestPipeSegment(): Int = (identifyLoop().size + 1) / 2

    /**
     * Second task: First identify the loop. Then identify all regions that are not part of the loop
     * by using a floodfill algorithm iteratively on all positions that are not part of any region
     * yet. At the end label the regions as inside or outside regions by traversing the loop again
     * while keeping track of the outside normal direction. The sum of the areas of all inside
     * regions is returned.
     */
    fun enclosedArea(): Int {
        val loop: Region = identifyLoop()
        val regions: MutableList<Set<Int>> = mutableListOf(loop)

        // Identify all regions
        for (id in 0 ..< maze.mRows * maze.nCols) {
            if (regions.none { it.contains(id) }) {
                regions.add(identifyRegion(Position(maze.mRows, maze.nCols, id), loop))
            }
        }

        val enclosed: MutableList<Boolean> = MutableList(regions.size) { true }
        enclosed[0] = false

        // Go through the loop from the loop segment with the lowest id
        val lowestID: Int = loop.min()
        var pos = Position(maze.mRows, maze.nCols, lowestID)
        var normal: Direction = Direction.NORTH
        var travelDirection: Direction = Direction.EAST
        do {
            try {
                val outsidePosition: Position = pos.copy().also { it.travel(normal) }
                enclosed[regions.indexOfFirst { it.contains(outsidePosition.id()) }] = false
            } catch (e: Exception) {}
            pos.travel(travelDirection)
            try {
                val outsidePosition: Position = pos.copy().also { it.travel(normal) }
                enclosed[regions.indexOfFirst { it.contains(outsidePosition.id()) }] = false
            } catch (e: Exception) {}

            normal = maze[pos]!!.outsideNormalDirection(travelDirection, normal)
            travelDirection = maze[pos]!!.traverse(travelDirection)
        } while (pos.id() != lowestID)

        return regions.filterIndexed { index, _ -> enclosed[index] }.map { it.size }.sum()
    }

    private fun identifyLoop(): Region {
        var pos = maze.startPos.copy()
        var travelDirection: Direction = maze[pos]!!.first
        var loop: Region = mutableSetOf<Int>()

        // Go through the maze until we loop back to the start
        do {
            loop.add(pos.id())
            pos.travel(travelDirection)
            travelDirection = maze[pos]!!.traverse(travelDirection)
        } while (pos != maze.startPos)

        return loop
    }

    private fun identifyRegion(pos: Position, loop: Set<Int>): Region {
        var region: Region = mutableSetOf<Int>(pos.id())

        val queue: Queue<Position> = LinkedList()
        queue.add(pos)

        while (queue.size > 0) {
            for (neighbour in queue.remove().neighbours()) {
                if (!loop.contains(neighbour.id()) && !region.contains(neighbour.id())) {
                    region.add(neighbour.id())
                    queue.add(neighbour)
                }
            }
        }

        return region
    }
}

private enum class Direction {
    NORTH {
        override fun opposite(): Direction = Direction.SOUTH

        override fun left(): Direction = Direction.WEST
    },
    EAST {
        override fun opposite(): Direction = Direction.WEST

        override fun left(): Direction = Direction.NORTH
    },
    SOUTH {
        override fun opposite(): Direction = Direction.NORTH

        override fun left(): Direction = Direction.EAST
    },
    WEST {
        override fun opposite(): Direction = Direction.EAST

        override fun left(): Direction = Direction.SOUTH
    };

    abstract fun opposite(): Direction

    abstract fun left(): Direction
}

private data class Position(val mRows: Int, val nCols: Int, var row: Int, var col: Int) {

    constructor(mRows: Int, nCols: Int, id: Int) : this(mRows, nCols, id / nCols, id % nCols)

    fun id(): Int = row * nCols + col

    fun travel(travelDirection: Direction): Unit {
        if (travelDirection == Direction.NORTH && row > 0) {
            row--
        } else if (travelDirection == Direction.EAST && col < nCols - 1) {
            col++
        } else if (travelDirection == Direction.SOUTH && row < mRows - 1) {
            row++
        } else if (travelDirection == Direction.WEST && col > 0) {
            col--
        } else {
            throw Exception("Error: Travelled outside of the grid!")
        }
    }

    fun neighbours(): List<Position> {
        val positions: MutableList<Position> = mutableListOf<Position>()
        if (row > 0) {
            positions.add(Position(mRows, nCols, row - 1, col))
        }
        if (row < mRows - 1) {
            positions.add(Position(mRows, nCols, row + 1, col))
        }
        if (col > 0) {
            positions.add(Position(mRows, nCols, row, col - 1))
        }
        if (col < nCols - 1) {
            positions.add(Position(mRows, nCols, row, col + 1))
        }
        return positions.toList()
    }
}

private class Pipe(val first: Direction, val second: Direction) {

    fun traverse(travelDirection: Direction): Direction =
        if (first == travelDirection.opposite()) {
            second
        } else if (second == travelDirection.opposite()) {
            first
        } else {
            throw Exception("Error: Invalid travel direction!")
        }

    fun outsideNormalDirection(travelDirection: Direction, previousNormal: Direction): Direction {
        if (first == second.opposite()) {
            return previousNormal
        }

        return if (first == travelDirection.opposite()) {
            if (travelDirection.left() == second) {
                travelDirection.opposite()
            } else {
                travelDirection
            }
        } else if (second == travelDirection.opposite()) {
            if (travelDirection.left() == first) {
                travelDirection.opposite()
            } else {
                travelDirection
            }
        } else {
            throw Exception("Error: Invalid travel direction!")
        }
    }

    companion object {
        infix fun from(id: Char): Pipe? =
            when (id) {
                '|' -> Pipe(Direction.NORTH, Direction.SOUTH)
                'J' -> Pipe(Direction.NORTH, Direction.WEST)
                'L' -> Pipe(Direction.NORTH, Direction.EAST)
                '-' -> Pipe(Direction.WEST, Direction.EAST)
                '7' -> Pipe(Direction.WEST, Direction.SOUTH)
                'F' -> Pipe(Direction.SOUTH, Direction.EAST)
                else -> null
            }
    }
}

private class Maze(initStr: String) {
    private var grid: MutableList<MutableList<Pipe?>> =
        initStr.lines().map { it.map { c -> Pipe from c }.toMutableList() }.toMutableList()
    val mRows = grid.size
    val nCols = grid[0].size
    val startPos: Position =
        initStr
            .lines()
            .indexOfFirst { it.contains('S') }
            .let { row -> Position(mRows, nCols, row, initStr.lines()[row].indexOf('S')) }

    // Identify the start pipe
    init {
        // Try traversing neighbouring pipes
        var pipeDirections: List<Direction> =
            Direction.values().filter {
                var tmpPos = startPos.copy()

                try {
                    tmpPos.travel(it)
                    this[tmpPos]?.let { pipe ->
                        pipe.traverse(it)
                        true
                    } ?: false
                } catch (e: Exception) {
                    false
                }
            }

        // Set start pipe if it is valid
        if (pipeDirections.size != 2) {
            throw Exception("Error: Start pipe not uniquely identifyable: $pipeDirections")
        }
        this[startPos] = Pipe(pipeDirections[0], pipeDirections[1])
    }

    operator fun get(pos: Position): Pipe? = grid[pos.row][pos.col]

    operator fun set(pos: Position, pipe: Pipe): Unit {
        grid[pos.row][pos.col] = pipe
    }
}
