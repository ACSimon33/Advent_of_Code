package aoc2023.day21.stepCounter

import java.util.LinkedList
import java.util.Queue

/** Step Counter Solver */
public class StepCounter(input: String) {
    /** 2D Grid of garden tiles. */
    private var garden: List<List<Ground>> =
        input.lines().map { it.map { c -> (Ground from c)!! }.toList() }.toList()

    /** Number of rows in the garden. */
    val mRows = garden.size

    /** Number of columns in the garden. */
    val nCols = garden[0].size

    /** First task: TODO */
    fun solution1(steps: Long, infinite: Boolean): Int {
        return calcDistances().count { it <= steps && checkParity(it, steps) }
    }

    private fun calcDistances(): MutableList<Long> {

        val distances: MutableList<Long> = MutableList(mRows * nCols) { Long.MAX_VALUE }

        // Find the start
        val row = garden.indexOfFirst { it.contains(Ground.Start) }
        val col = garden[row].indexOf(Ground.Start)
        val startPos = Position(mRows, nCols, row, col)
        distances[startPos.id()] = 0L

        val queue: Queue<Position> = LinkedList()
        queue.add(startPos)

        while (queue.size > 0) {
            val pos = queue.remove()
            for (neighbour in pos.neighbours()) {
                val tile = garden[neighbour.row][neighbour.col]
                if (tile == Ground.Garden && distances[neighbour.id()] > distances[pos.id()] + 1L) {
                    distances[neighbour.id()] = distances[pos.id()] + 1L
                    queue.add(neighbour)
                }
            }
        }

        return distances
    }
}

private fun checkParity(a: Long, b: Long): Boolean = (a % 2) == (b % 2)

/** Class identifying a position [row], [col] in a grid of size [mRows] x [nCols]. */
private data class Position(val mRows: Int, val nCols: Int, var row: Int, var col: Int) {

    /** Create the position with a given [id] for a grid of size [mRows] x [nCols]. */
    constructor(mRows: Int, nCols: Int, id: Int) : this(mRows, nCols, id / nCols, id % nCols)

    /** Index (ID) of the position. */
    fun id(): Int = row * nCols + col

    /** Create a list of neighbouring positions. */
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

/** Enum for different ground types (garden or rock). */
private enum class Ground {
    Start,
    Garden,
    Rock;

    var distance: Long = Long.MAX_VALUE

    companion object {
        /** Create a ground type from its char [id]. */
        infix fun from(id: Char): Ground? =
            when (id) {
                'S' -> Start
                '.' -> Garden
                '#' -> Rock
                else -> null
            }
    }
}
