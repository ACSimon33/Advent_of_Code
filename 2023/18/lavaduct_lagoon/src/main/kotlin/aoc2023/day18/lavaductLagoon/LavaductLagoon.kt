package aoc2023.day18.lavaductLagoon

/** Lavaduct Lagoon Solver */
public class LavaductLagoon(val input: String) {

    /** First task: Extract the line segments from the instructions and calculate the volume. */
    fun volumeWithNormalInstructions(): Long {
        val polygon: List<LineSegment> =
            input.lines().map {
                Regex("([UDLR]{1}) ([0-9]+)").find(it)!!.let {
                    LineSegment(
                        (Direction from it.groups[1]!!.value[0])!!,
                        it.groups[2]!!.value.toLong()
                    )
                }
            }

        return numberOfContainedPoints(polygon)
    }

    /** Second task: Extract the line segments from the color codes and calculate the volume. */
    fun volumeWithHexadecimalInstructions(): Long {
        val polygon: List<LineSegment> =
            input.lines().map {
                Regex("\\(#([0-9a-f]{5})([0-3]{1})\\)").find(it)!!.let {
                    LineSegment(
                        (Direction from it.groups[2]!!.value.toInt())!!,
                        it.groups[1]!!.value.toLong(radix = 16)
                    )
                }
            }

        return numberOfContainedPoints(polygon)
    }

    /**
     * Calculate the number of integer points inside a [polygo], given by its line segments. Uses
     * the showlace formula in combination with Pick's theorem to calculate the amount of exterior
     * and interior points and returns their sum.
     */
    private fun numberOfContainedPoints(polygon: List<LineSegment>): Long {
        val points = mutableListOf<Point>(Point(0, 0))
        var exteriorPoints: Long = 0
        for (segment in polygon) {
            points.add(points.last() + segment)
            exteriorPoints += segment.length
        }

        // Shoelace formula (2A = sum_1^n (x_i * y_i+1 - x_i+1 * y_i))
        var volumeTwice: Long = 0
        points.reversed().zipWithNext().forEach { (p1, p2) -> volumeTwice += p1 * p2 }

        // Pick's theorem [ A = i + b/2 - 1  =>  i = A - b/2 + 1  =>  i = (2A - b) / 2 + 1 ]
        val interiorPoints: Long = (volumeTwice - exteriorPoints) / 2 + 1

        return exteriorPoints + interiorPoints
    }
}

/** 2D point with integer coordinates ([x], [y]). */
private data class Point(val x: Long, val y: Long) {

    /** Add a line [segment] to this point and return the new point at the other end of the line. */
    operator fun plus(segment: LineSegment): Point =
        when (segment.direction) {
            Direction.NORTH -> Point(x - segment.length, y)
            Direction.SOUTH -> Point(x + segment.length, y)
            Direction.WEST -> Point(x, y - segment.length)
            Direction.EAST -> Point(x, y + segment.length)
        }

    /** Calculate the cross product between this point and an [other]. */
    operator fun times(other: Point): Long = x * other.y - other.x * y
}

/** Line segment with a given [direction] and a [length]. */
private data class LineSegment(val direction: Direction, val length: Long)

/** Class identifying a horizontal or vertical direction. */
private enum class Direction {
    NORTH,
    EAST,
    SOUTH,
    WEST;

    companion object {
        /** Create a direction from its character [id]. */
        infix fun from(id: Char): Direction? =
            when (id) {
                'U' -> NORTH
                'L' -> WEST
                'R' -> EAST
                'D' -> SOUTH
                else -> null
            }

        /** Create a direction from its integer [id]. */
        infix fun from(id: Int): Direction? =
            when (id) {
                3 -> NORTH
                2 -> WEST
                0 -> EAST
                1 -> SOUTH
                else -> null
            }
    }
}
