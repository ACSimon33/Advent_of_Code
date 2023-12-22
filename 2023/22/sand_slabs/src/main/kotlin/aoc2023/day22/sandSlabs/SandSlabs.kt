package aoc2023.day22.sandSlabs

import kotlin.math.max
import kotlin.math.min

/** Sand Slabs Solver */
public class SandSlabs(input: String) {
    private val bricks: List<Brick> = input.lines().map { Brick(it) }
    private val xSize: Int = bricks.maxOf { it.endCubes.maxOf { it.x } } + 1
    private val ySize: Int = bricks.maxOf { it.endCubes.maxOf { it.y } } + 1
    private val zSize: Int = bricks.maxOf { it.endCubes.maxOf { it.z } } + 2
    private val heap = MutableList<Int>(xSize * ySize * zSize) { -1 }
    private var predecessors: List<Set<Int>>
    private var successors: List<Set<Int>>

    init {
        // Initialize 3D heap with ground and bricks
        (0 ..< xSize * ySize).forEach { heap[it] = Int.MAX_VALUE }
        bricks.forEachIndexed { index, brick -> fillHeap(brick, index) }

        // Let the bricks fall until they settle
        while (settle()) {}

        // Figure out the predecessors of each brick
        predecessors =
            bricks.map {
                it.bottomCubes
                    .map { heap[it.id(xSize, ySize) - xSize * ySize] }
                    .filter { it >= 0 }
                    .toSet()
            }

        // Figure out the successors of each brick
        successors =
            bricks.map {
                it.topCubes
                    .map { heap[it.id(xSize, ySize) + xSize * ySize] }
                    .filter { it >= 0 }
                    .toSet()
            }
    }

    private fun settle(): Boolean {
        var changed: Boolean = false

        for ((index, brick) in bricks.withIndex()) {
            if (brick.bottomCubes.all { heap[it.id(xSize, ySize) - xSize * ySize] < 0 }) {
                fillHeap(brick, -1)
                brick.fall()
                fillHeap(brick, index)
                changed = true
            }
        }

        return changed
    }

    private fun fillHeap(brick: Brick, value: Int): Unit =
        brick.allCubes.forEach { heap[it.id(xSize, ySize)] = value }

    /** First task: TODO */
    fun solution1(): Int =
        successors.withIndex().count { (missingBrick, succ) ->
            succ.all { isGroundedWithout(predecessors, it, missingBrick) }
        }

    /** First task: TODO */
    fun solution2(): Int =
        (0 ..< bricks.size).fold(0) { acc, missingBrick->
            acc +
                cumulativeSuccessors(successors, missingBrick).count {
                    !isGroundedWithout(predecessors, it, missingBrick)
                }
        }

    private fun isGroundedWithout(
        predecessors: List<Set<Int>>,
        currentBrick: Int,
        missingBrick: Int
    ): Boolean =
        if (currentBrick == missingBrick) {
            false
        } else if (predecessors[currentBrick].contains(Int.MAX_VALUE)) {
            true
        } else {
            predecessors[currentBrick].any { isGroundedWithout(predecessors, it, missingBrick) }
        }

    private fun cumulativeSuccessors(successors: List<Set<Int>>, currentBrick: Int): Set<Int> {
        val allSuccessors: MutableSet<Int> = successors[currentBrick].toMutableSet()
        successors[currentBrick].forEach {
            allSuccessors.addAll(cumulativeSuccessors(successors, it))
        }
        return allSuccessors.toSet()
    }
}

private class Brick(initStr: String) {
    val endCubes: List<Cube> = initStr.split('~').map { Cube from it }
    val bottomCubes = mutableListOf<Cube>()
    val topCubes = mutableListOf<Cube>()
    val allCubes = mutableListOf<Cube>()

    init {
        if (endCubes[0].x != endCubes[1].x) {
            (min(endCubes[0].x, endCubes[1].x)..max(endCubes[0].x, endCubes[1].x)).forEach {
                bottomCubes.add(Cube(it, endCubes[0].y, endCubes[0].z))
            }
            topCubes.addAll(bottomCubes)
            allCubes.addAll(bottomCubes)
        } else if (endCubes[0].y != endCubes[1].y) {
            (min(endCubes[0].y, endCubes[1].y)..max(endCubes[0].y, endCubes[1].y)).forEach {
                bottomCubes.add(Cube(endCubes[0].x, it, endCubes[0].z))
            }
            topCubes.addAll(bottomCubes)
            allCubes.addAll(bottomCubes)
        } else {
            bottomCubes.add(Cube(endCubes[0].x, endCubes[0].y, min(endCubes[0].z, endCubes[1].z)))
            topCubes.add(Cube(endCubes[0].x, endCubes[0].y, max(endCubes[0].z, endCubes[1].z)))
            allCubes.addAll(bottomCubes)
            allCubes.addAll(topCubes)
        }
    }

    fun fall(): Unit = allCubes.forEach { it.z-- }
}

/** Class identifying a position [row], [col] in a grid of size [mRows] x [nCols]. */
private data class Cube(val x: Int, val y: Int, var z: Int) {

    /** Index (ID) of the position. */
    fun id(xSize: Int, ySize: Int): Int = z * (xSize * ySize) + y * xSize + x

    companion object {
        infix fun from(initStr: String): Cube {
            val coordinates: List<Int> = initStr.split(',').map { it.toInt() }
            return Cube(coordinates[0], coordinates[1], coordinates[2])
        }
    }
}
