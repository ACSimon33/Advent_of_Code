package aoc2023.day23.aLongWalk

import java.util.LinkedList
import java.util.Queue

/** A Long Walk Solver */
public class ALongWalk(input: String) {

    /** List of all tiles stored as strings. */
    private val map: List<String> = input.lines()
    /** Number of rows in the map. */
    private val mRows: Int = map.size
    /** Number of columns in the map. */
    private val nCols: Int = map[0].length

    /** List of all hiking trail junctions. */
    private val junctions = mutableListOf<TrailJunction>()
    /** Adjacency matrix which stores the trail lengths between all junctions. */
    private val trails: MutableList<MutableList<Int>>

    // Detect junctions and trails lengths
    init {
        // Add junction for starting position
        junctions.add(
            TrailJunction(Position(mRows, nCols, 0, 1), emptyList(), listOf(Direction.SOUTH))
        )

        // Detect junctions in the map
        for (row in 1 ..< mRows - 1) {
            for (col in 1 ..< nCols - 1) {
                if (map[row][col] == '.') {
                    detectJunction(row, col)?.let { junctions.add(it) }
                }
            }
        }

        // Add junction for ending position
        junctions.add(
            TrailJunction(
                Position(mRows, nCols, mRows - 1, nCols - 2),
                listOf(Direction.NORTH),
                emptyList()
            )
        )

        // Measure trails by following the junction exits until we reach another junction. This will
        // create a adjacency matrix for the trail graph
        trails =
            MutableList<MutableList<Int>>(junctions.size) { MutableList<Int>(junctions.size) { 0 } }
        for ((i, junction) in junctions.withIndex()) {
            for (exit in junction.exits) {
                val pos = Position(mRows, nCols, junction.pos.row, junction.pos.col)
                var steps = 0
                var travelDirection = exit

                // The start junction is not a real junction so don't do the initial steps
                if (i > 0) {
                    pos.travel(travelDirection)
                    pos.travel(travelDirection)
                    steps += 2
                }

                var foundNextJunction: Boolean = false
                var moved: Boolean = true
                while (!foundNextJunction && moved) {
                    moved = false
                    for ((dir, neighbour) in pos.neighbours()) {
                        if (dir == travelDirection.opposite()) {
                            continue
                        }

                        // Check neighbour for the trail
                        if (map[neighbour.row][neighbour.col] == '.') {
                            travelDirection = dir
                            pos.travel(travelDirection)
                            steps++
                            moved = true
                            break
                        }

                        // Check neighbour for a slope / junction
                        if ((Direction from map[neighbour.row][neighbour.col]) == dir) {
                            travelDirection = dir
                            pos.travel(travelDirection)
                            pos.travel(travelDirection)
                            steps += 2
                            foundNextJunction = true
                            break
                        }
                    }
                }

                junctions
                    .withIndex()
                    .find { it.value.pos == pos }
                    ?.let { (j, _) -> trails[i][j] = steps }
                    ?: throw IllegalStateException("Could not find next junction")
            }
        }
    }

    /**
     * Check if the position ([row], [col]) is a junction by searching for slopes (<,>,^,v) in the
     * neighbouing positions.
     */
    private fun detectJunction(row: Int, col: Int): TrailJunction? =
        if (map[row][col] == '.') {
            val pos = Position(mRows, nCols, row, col)
            val slopes = pos.neighbours().map { Direction from map[it.value.row][it.value.col] }
            TrailJunction.from(pos, slopes)
        } else {
            null
        }

    /** Convert the trail graph into dot graph format. */
    private fun toDot(): Unit {
        println("digraph G {")
        for (i in 0 until trails.size) {
            for (j in 0 until trails[i].size) {
                if (trails[i][j] > 0) {
                    print("  $i -> $j [label=")
                    print(trails[i][j])
                    println("]")
                }
            }
        }
        println("}")
    }

    /** First task: Find the longest path in the directed (with slopes) graph of trails. */
    fun longestPathWithSlopes(): Int {
        val distances = MutableList<Int>(junctions.size) { 0 }
        val queue: Queue<Int> = LinkedList()
        queue.add(0)

        // Dijkstra's algorithm without keeping track of visited nodes and without priority queue
        while (!queue.isEmpty()) {
            val i: Int = queue.remove()
            for (j in 0 until junctions.size) {
                if (trails[i][j] > 0) {
                    val newDistance: Int = distances[i] + trails[i][j]
                    if (distances[j] < newDistance) {
                        distances[j] = newDistance
                        queue.add(j)
                    }
                }
            }
        }

        return distances.last()
    }

    /** First task: Find the longest path in the undirected (without slopes) graph of trails. */
    fun longestPathWithoutSlopes(): Int {
        // Mirror the adjacency matrix to make the graph undirected
        for (i in 0 until trails.size) {
            for (j in 0 until trails[i].size) {
                if (trails[i][j] > 0) {
                    trails[j][i] = trails[i][j]
                }
            }
        }

        return calcLongestPath()
    }

    /**
     * Calculate the longest path from the [currentNode] to the last node. We are only allowed to
     * visit each node once, so we keep track of the [visited] nodes with a binary number.
     */
    private fun calcLongestPath(currentNode: Int = 0, visited: ULong = 0UL): Int {
        val trailToEnd = trails[currentNode].last()
        if (trailToEnd > 0) {
            return trailToEnd
        }

        var longestPath = 0
        for (i in 0 until trails.size) {
            val trail = trails[currentNode][i]
            if (trail > 0 && (visited and (1UL shl i)) == 0UL) {
                longestPath = maxOf(longestPath, trail + calcLongestPath(i, visited or (1UL shl i)))
            }
        }
        return longestPath
    }
}

/** Class identifying a othogonal direction. The direction knows its opposite direction. */
private enum class Direction {
    NORTH {
        /** Opposite of NORTH is SOUTH. */
        override fun opposite(): Direction = Direction.SOUTH
    },
    EAST {
        /** Opposite of EAST is SOUTH. */
        override fun opposite(): Direction = Direction.WEST
    },
    SOUTH {
        /** Opposite of SOUTH is NORTH. */
        override fun opposite(): Direction = Direction.NORTH
    },
    WEST {
        /** Opposite of WEST is EAST. */
        override fun opposite(): Direction = Direction.EAST
    },
    NONE {
        /** Opposite of NONE is NONE. */
        override fun opposite(): Direction = Direction.NONE
    };

    /** Abstract: Opposite direction. */
    abstract fun opposite(): Direction

    companion object {
        /** Get the direction of a given [slope]. */
        infix fun from(slope: Char): Direction =
            when (slope) {
                '^' -> NORTH
                '>' -> EAST
                'v' -> SOUTH
                '<' -> WEST
                else -> NONE
            }
    }
}

/** Class identifying a position [row], [col] in a grid of size [mRows] x [nCols]. */
private data class Position(val mRows: Int, val nCols: Int, var row: Int, var col: Int) {

    /** Travel in the given [travelDirection]. Throw an exception if we leave the grid. */
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

    /** Create a list of all neighbouring positions. */
    fun neighbours(): Map<Direction, Position> {
        val positions: MutableMap<Direction, Position> = mutableMapOf<Direction, Position>()
        if (row > 0) {
            positions[Direction.NORTH] = Position(mRows, nCols, row - 1, col)
        }
        if (col < nCols - 1) {
            positions[Direction.EAST] = Position(mRows, nCols, row, col + 1)
        }
        if (row < mRows - 1) {
            positions[Direction.SOUTH] = Position(mRows, nCols, row + 1, col)
        }
        if (col > 0) {
            positions[Direction.WEST] = Position(mRows, nCols, row, col - 1)
        }
        return positions.toMap()
    }
}

/**
 * Trail junction with information about its [position], the incoming trails [entrances] as well as
 * the outgoing trails [exits].
 */
private data class TrailJunction(
    val pos: Position,
    val entrances: List<Direction>,
    val exits: List<Direction>
) {

    companion object {
        /**
         * Create a junction from a given [position] and a list of [slopes]. The slopes are stored
         * as directions. If the slope direction is the same as the neighbouring tile it is an exit
         * of the junction. If it's the opposite direction it's an entrance. Each junction needs at
         * least on entrance and one exit, otherwise return null.
         */
        fun from(position: Position, slopes: List<Direction>): TrailJunction? {
            val entrances: MutableList<Direction> = mutableListOf<Direction>()
            val exits: MutableList<Direction> = mutableListOf<Direction>()
            for (dir in Direction.values()) {
                if (dir == Direction.NONE) {
                    continue
                }

                if (slopes[dir.ordinal] == dir) {
                    exits.add(dir)
                } else if (slopes[dir.ordinal] == dir.opposite()) {
                    entrances.add(dir)
                }
            }
            if (entrances.size >= 1 && exits.size >= 1) {
                return TrailJunction(position, entrances, exits)
            }

            return null
        }
    }
}
