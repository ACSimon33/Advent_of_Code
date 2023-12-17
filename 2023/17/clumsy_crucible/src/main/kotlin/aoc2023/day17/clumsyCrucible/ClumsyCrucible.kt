package aoc2023.day17.clumsyCrucible

import java.util.PriorityQueue

/** Clumsy Crucible Solver */
public class ClumsyCrucible(input: String) {

    /** 2D Grid of vertices. */
    private val vertices: List<List<GridVertex>> =
        input.lines().map { it -> it.map { c -> GridVertex(c.toString().toInt()) } }

    /** Number of rows in the grid. */
    private val rows: Int = vertices.size

    /** Number of columns in the grid. */
    private val cols: Int = vertices[0].size

    // Initialize vertex neighbours
    init {
        for (i in 0 ..< rows) {
            for (j in 0 ..< cols) {
                if (i > 0) {
                    vertices[i][j].neighbours[Direction.NORTH.ordinal] = vertices[i - 1][j]
                }
                if (i < rows - 1) {
                    vertices[i][j].neighbours[Direction.SOUTH.ordinal] = vertices[i + 1][j]
                }
                if (j > 0) {
                    vertices[i][j].neighbours[Direction.WEST.ordinal] = vertices[i][j - 1]
                }
                if (j < cols - 1) {
                    vertices[i][j].neighbours[Direction.EAST.ordinal] = vertices[i][j + 1]
                }
            }
        }
    }

    /** Find the least heat loss with a step sizes between [minSteps] and [maxSteps]. */
    fun leastHeatLoss(minSteps: Int, maxSteps: Int): Int =
        restrictedDijkstra(vertices[0][0], vertices[rows - 1][cols - 1], minSteps, maxSteps)

    /**
     * Run a dijkstra algorithm to find the shortest path between the [start] node and [end] node.
     * The algorithm is restricted by the amount of steps that we are allowed to go consecutively in
     * one direction. We need to go at least [minSteps] and maximal [maxSteps] before changing the
     * direction again.
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

        // List of valid directions
        val directions = listOf(Direction.NORTH, Direction.EAST, Direction.SOUTH, Direction.WEST)

        // Continue to update the distances until the queue is empty
        while (!vertexQueue.isEmpty()) {
            val v: GridVertex = vertexQueue.remove()

            // Update distances of neighbours and add them to the queue if something changed
            for (direction in directions) {
                v.neighbours[direction.ordinal]?.let {
                    if (it.travel(direction, minSteps, maxSteps)) {
                        vertexQueue.add(it)
                    }
                }
            }
        }

        // Return minimal valid distance
        return end.mininalDistance(minSteps)
    }
}

/** A vertex in the grid with a given [weight] for incoming edges. */
private class GridVertex(val weight: Int) {

    /** Map of travel histories to distances. */
    val distances = mutableMapOf<Pair<Direction, Int>, Int>()

    /** List of neighbouring vertices. */
    val neighbours: MutableList<GridVertex?> = mutableListOf(null, null, null, null)

    /**
     * Return the minimal distance of the vertex under the condition that we need to travel at
     * least [minSteps] steps consecutively in one direction before stopping at the current vertex.
     */
    fun mininalDistance(minSteps: Int = 0): Int =
        distances.filter { it.key.second >= minSteps }.minOf { it.value }

    /**
     * Travel into the vertex in a given [direction] and update the distances by going through all
     * travel histories from the previous vertex. If travelling to the current vertex is valid under
     * the constraints of [minSteps] and [maxSteps] we update the corresponding distance. Returns
     * true if any distance was updated.
     */
    fun travel(direction: Direction, minSteps: Int, maxSteps: Int): Boolean {
        var updated: Boolean = false
        val previous = neighbours[direction.opposite().ordinal]!!

        for ((prevHistory, prevDistance) in previous.distances) {
            newDirectionHistory(prevHistory, direction, minSteps, maxSteps)?.let {
                val currentDist: Int = distances.getOrPut(it, { Int.MAX_VALUE })
                val newDist: Int = prevDistance + weight
                if (newDist < currentDist) {
                    distances[it] = newDist
                    updated = true
                }
            }
        }

        return updated
    }

    /**
     * Calculate a new direction history given a previous [history] and the current travel
     * [direction]. If the travel would be invalid under the constraints of [minSteps] and
     * [maxSteps] we return null.
     */
    private fun newDirectionHistory(
        history: Pair<Direction, Int>,
        direction: Direction,
        minSteps: Int,
        maxSteps: Int
    ): Pair<Direction, Int>? {

        // We are not allowed to move more steps in the same direction than maxSteps
        if (history.first == direction) {
            if (history.second < maxSteps) {
                return Pair(history.first, history.second + 1)
            } else {
                return null
            }
        }

        // We are not allowed to go back immediately
        if (history.first == direction.opposite()) {
            return null
        }

        // If there are already minSteps consecutive steps we are allowed every direction
        if (history.second >= minSteps || history.first == Direction.NONE) {
            return Pair(direction, 1)
        }

        return null
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
}
