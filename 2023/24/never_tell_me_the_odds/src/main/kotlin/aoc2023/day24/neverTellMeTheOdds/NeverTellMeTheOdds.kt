package aoc2023.day24.neverTellMeTheOdds

import space.kscience.kmath.real.*
import space.kscience.kmath.linear.*
import space.kscience.kmath.linear.*

/** Never Tell Me The Odds Solver */
public class NeverTellMeTheOdds(input: String) {
    private val trajectories: List<Line> = input.lines().map { Line from it }

    /** First task: TODO */
    fun solution1(minVal: Double, maxVal: Double): Int {
        var intersectionsInside: Int = 0
        /*for (i in 0 until trajectories.size) {  
            for (j in i + 1 until trajectories.size) {
                val t = trajectories[i].intersect(trajectories[j], 2)
                if (t == null) {
                    continue
                }

                val intersection = trajectories[i].getPoint(t[0])
                // Check if the intersection is in the future and is inside the range
                if (t.all{ it > 0.0 } && intersection[0] <= maxVal && intersection[0] >= minVal &&
                    intersection[1] <= maxVal && intersection[1] >= minVal) {
                    intersectionsInside++
                }
            }
        }*/

        return intersectionsInside
    }

    /** Second task: TODO */
    fun solution2(): Int {
        return 1
    }
}


private class Line(val support: DoubleVector, val slope: DoubleVector) {
    private val dims: Int = support.size

    init {
        require(support.size == slope.size) { "Support and slope must be the same size" }
        require(dims >= 2) { "Dimensions must be greater or equal 2" }
    }

    fun intersect(other: Line, dimensions: Int = dims): Vector? {
        require(dims == other.dims) { "Lines must have the same number of dimensions" }
        require(dimensions <= dims) { "Dimensions must be less than or equal to the number of dimensions of the lines" }
        require(dimensions >= 2) { "Dimensions must be greater or equal 2" }

        if (dimensions == 2) {
            val t = Vector(2)
            t[1] = (other.support[1] - support[1]) * slope[0]
            t[1] = t[1] - (other.support[0] - support[0]) * slope[1]

            val div = slope[1] * other.slope[0] - slope[0] * other.slope[1]
            if (div == 0.0) {
                return null
            }

            t[1] = t[1] / div
            t[0] = (other.support[0] - support[0] + t[1] * other.slope[0]) / slope[0]
            return t
        }

        return null
    }

    fun getPoint(t: Double): Vector = (support + slope * t)*/

    companion object {
        infix fun from(initStr: String): Line {
            val (supportStr, slopeStr) = initStr.split("@")

            val (bx, by, bz) = supportStr.split(",").map { it.trim().toDouble() }
            val support = DoubleVector(bx, by, bz)

            val (mx, my, mz) = slopeStr.split(",").map { it.trim().toDouble() }
            val slope = DoubleVector(mx, my, mz)

            return Line(support, slope)
        }
    }
}
