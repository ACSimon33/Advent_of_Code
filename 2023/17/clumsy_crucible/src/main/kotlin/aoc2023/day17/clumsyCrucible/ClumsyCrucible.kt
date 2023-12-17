package aoc2023.day17.clumsyCrucible

import java.util.PriorityQueue

/** Clumsy Crucible Solver */
public class ClumsyCrucible(input: String) {
    private val vertices: List<List<GridVertex>> =
        input.lines().mapIndexed { row, it -> it.mapIndexed { col, c -> GridVertex(row, col, c) } }
    val rows: Int = vertices.size
    val cols: Int = vertices[0].size

    /** First task: Find the shortest path with a step size between 1 and 3. */
    fun solution1(): Int = restrictedDijkstra(vertices[0][0], vertices[rows - 1][cols - 1], 1, 3)

    /** First task: Find the shortest path with a step size between 4 and 10. */
    fun solution2(): Int = restrictedDijkstra(vertices[0][0], vertices[rows - 1][cols - 1], 4, 10)

    /**
     * Run a dijkstra algorithm to find the shortest path between the [start] node and [end] node.
     * The algorithm is restricted by the amount of steps that we are allowed to go consecutively
     * in one direction. We need to go at least [minSteps] and maximal [maxSteps] before changing
     * the direction again.
     */
    private fun restrictedDijkstra(
        start: GridVertex,
        end: GridVertex,
        minSteps: Int,
        maxSteps: Int
    ): Int {

        // Reset vertex distances
        for (v in vertices.flatten()) {
            v.distances.clear()
        }

        // Initialize vertex priority queue with the start vertex
        val distanceComparator: Comparator<GridVertex> = compareBy { it.mininalDistance() }
        val vertexQueue = PriorityQueue<GridVertex>(distanceComparator)
        start.distances.put(Pair(Direction.NONE, 0), 0)
        vertexQueue.add(start)

        // Continue to update the distances until the queue is empty
        while (!vertexQueue.isEmpty()) {
            val v: GridVertex = vertexQueue.remove()
            val currentRow: Int = v.pos.row
            val currentCol: Int = v.pos.col

            // Collect valid neighbours
            val neighbours = mutableListOf<GridVertex>()
            if (currentRow > 0) {
                neighbours.add(vertices[currentRow - 1][currentCol])
            }
            if (currentRow < rows - 1) {
                neighbours.add(vertices[currentRow + 1][currentCol])
            }
            if (currentCol > 0) {
                neighbours.add(vertices[currentRow][currentCol - 1])
            }
            if (currentCol < cols - 1) {
                neighbours.add(vertices[currentRow][currentCol + 1])
            }

            // Update distances of neighbours and add them to the queue if something changed
            for (neighbour in neighbours) {
                if (neighbour.travelFrom(v, minSteps, maxSteps)) {
                    vertexQueue.add(neighbour)
                }
            }
        }

        return end.mininalDistance(minSteps)
    }
}

private class GridVertex(row: Int, col: Int, label: Char) {
    val pos = Position(row, col)
    val weight: Int = label.toString().toInt()
    val distances = mutableMapOf<Pair<Direction, Int>, Int>()

    fun mininalDistance(minSteps: Int = 0): Int =
        distances.filter { it.key.second >= minSteps }.minOf { it.value }

    fun travelFrom(other: GridVertex, minSteps: Int, maxSteps: Int): Boolean {
        val dir = getTravelDirection(other.pos)!!
        var updated: Boolean = false

        for ((otherHistory, otherDistance) in other.distances) {
            newDirectionHistory(otherHistory, dir, minSteps, maxSteps)?.let {
                val currentDist: Int = distances.getOrPut(it, { Int.MAX_VALUE })
                val newDist: Int = otherDistance + weight
                if (newDist < currentDist) {
                    distances[it] = newDist
                    updated = true
                }
            }
        }

        return updated
    }

    private fun newDirectionHistory(
        history: Pair<Direction, Int>,
        dir: Direction,
        minSteps: Int,
        maxSteps: Int
    ): Pair<Direction, Int>? {

        // We are not allowed to move more steps in the same direction than maxSteps
        if (history.first == dir) {
            if (history.second < maxSteps) {
                return Pair(history.first, history.second + 1)
            } else {
                return null
            }
        }

        // We are not allowed to go back immediately
        if (history.first == dir.opposite()) {
            return null
        }

        // If there are already minSteps consecutive steps we are allowed every direction
        if (history.second >= minSteps || history.first == Direction.NONE) {
            return Pair(dir, 1)
        }

        return null
    }

    private fun getTravelDirection(otherPos: Position): Direction? =
        if (otherPos.row > pos.row) {
            Direction.NORTH
        } else if (otherPos.col < pos.col) {
            Direction.EAST
        } else if (otherPos.row < pos.row) {
            Direction.SOUTH
        } else if (otherPos.col > pos.col) {
            Direction.WEST
        } else {
            null
        }
}

private data class Position(val row: Int, val col: Int)

/** Class identifying a othogonal direction. The direction knows its opposite and left direction. */
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
}
