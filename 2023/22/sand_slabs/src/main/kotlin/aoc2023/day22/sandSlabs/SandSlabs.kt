package aoc2023.day22.sandSlabs

import kotlin.math.max
import kotlin.math.min

/** Sand Slabs Solver */
public class SandSlabs(input: String) {
    private val bricks: List<Brick> = input.lines().map { Brick(it) }
    private val xSize: Int = bricks.maxOf { it.endCubes.maxOf { it.x } } + 1
    /** Size of the 3D space in y direction. */
    private val ySize: Int = bricks.maxOf { it.endCubes.maxOf { it.y } } + 1
    /** Size of the 3D space in z direction. */
    private val zSize: Int = bricks.maxOf { it.endCubes.maxOf { it.z } } + 2

    /** Grid containing information about the location of all bricks. */
    private val heap = MutableList<Int>(xSize * ySize * zSize) { -1 }
    /** List of predecessor sets for each brick. */
    private var predecessors: List<Set<Int>>
    /** List of successor sets for each brick. */
    private var successors: List<Set<Int>>
    /** List of a cumulative successor sets for each brick. */
    private var cumulativeSuccessors: MutableList<MutableSet<Int>?>

    init {
        // Initialize 3D heap with ground and bricks
        (0 ..< xSize * ySize).forEach { heap[it] = Int.MAX_VALUE }
        bricks.forEachIndexed { index, brick -> fillHeap(brick, index) }

        // Let the bricks fall until they settle and sort them by height again
        while (settle()) {}
        // bricks = bricks.sorted()

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

        // Create cumulative successor sets
        cumulativeSuccessors = MutableList(bricks.size) { null }
        for (i in (0 ..< bricks.size)) {
            if (cumulativeSuccessors[i] == null) {
                accumulateSuccessors(i)
            }
        }
    }

    /** Let the levetating bricks fall. Return true if any brick changed its position. */
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

    /** Fill the heap with the given [value] at all cube positions of the given [brick]. */
    private fun fillHeap(brick: Brick, value: Int): Unit =
        brick.allCubes.forEach { heap[it.id(xSize, ySize)] = value }

    /** Accumulate successors for the [currentBrick]. */
    private fun accumulateSuccessors(currentBrick: Int): Unit {
        cumulativeSuccessors[currentBrick] = successors[currentBrick].toMutableSet()
        successors[currentBrick].forEach {
            if (cumulativeSuccessors[it] == null) {
                accumulateSuccessors(it)
            }
            cumulativeSuccessors[currentBrick]!!.addAll(cumulativeSuccessors[it]!!)
        }
    }

    /** Check if the [currentBrick] is connected to the ground without the [missingBrick]. */
    private fun isGroundedWithout(currentBrick: Int, missingBrick: Int): Boolean =
        if (currentBrick == missingBrick) {
            false
        } else if (predecessors[currentBrick].contains(Int.MAX_VALUE)) {
            true
        } else {
            predecessors[currentBrick].any { isGroundedWithout(it, missingBrick) }
        }

    /**
     * First task: Calculate how many bricks can be removed individully without triggering an
     * avelanche.
     */
    fun amountOfDisintegratableBricks(): Int =
        successors.withIndex().count { (missingBrick, succ) ->
            succ.all { isGroundedWithout(it, missingBrick) }
        }

    /**
     * First task: Calculate the sum of how many bricks would fall if each brick was disintegrated
     * individually.
     */
    fun amountOfFallingBricks(): Int =
        (0 ..< bricks.size).fold(0) { acc, missingBrick ->
            acc +
                cumulativeSuccessors[missingBrick]!!.count { !isGroundedWithout(it, missingBrick) }
        }
}

/** Brick of sand initialized from an [initStr]. */
private class Brick(initStr: String) {

    /** List of end cubes (should be 2). */
    val endCubes: List<Cube> = initStr.split('~').map { Cube from it }
    /** Cubes in the brick with the lowest height. */
    val bottomCubes = mutableListOf<Cube>()
    /** Cubes in the brick with the highest height. */
    val topCubes = mutableListOf<Cube>()
    /** All cubes in the brick. */
    val allCubes = mutableListOf<Cube>()

    // Initialize the cubes contained in this brick
    init {
        if (endCubes[0].x != endCubes[1].x) {
            // Horizontal brick (in x direction)
            (min(endCubes[0].x, endCubes[1].x)..max(endCubes[0].x, endCubes[1].x)).forEach {
                bottomCubes.add(Cube(it, endCubes[0].y, endCubes[0].z))
            }
            topCubes.addAll(bottomCubes)
            allCubes.addAll(bottomCubes)
        } else if (endCubes[0].y != endCubes[1].y) {
            // Horizontal brick (in y direction)
            (min(endCubes[0].y, endCubes[1].y)..max(endCubes[0].y, endCubes[1].y)).forEach {
                bottomCubes.add(Cube(endCubes[0].x, it, endCubes[0].z))
            }
            topCubes.addAll(bottomCubes)
            allCubes.addAll(bottomCubes)
        } else {
            // Vertical brick (in z direction)
            bottomCubes.add(Cube(endCubes[0].x, endCubes[0].y, min(endCubes[0].z, endCubes[1].z)))
            topCubes.add(Cube(endCubes[0].x, endCubes[0].y, max(endCubes[0].z, endCubes[1].z)))
            allCubes.addAll(bottomCubes)
            allCubes.addAll(topCubes)
        }
    }

    /** Let the brick fall down (reduce height of all cubes by one). */
    fun fall(): Unit = allCubes.forEach { it.z-- }
}

/** Class identifying a position ([x], [y], [z]) of a unit cube in 3D space. */
private data class Cube(val x: Int, val y: Int, var z: Int) {

    /** Flattened index (ID) of the position. */
    fun id(xSize: Int, ySize: Int): Int = z * (xSize * ySize) + y * xSize + x

    companion object {
        /** Initialize the position from a [initStr] string. */
        infix fun from(initStr: String): Cube {
            val coordinates: List<Int> = initStr.split(',').map { it.toInt() }
            return Cube(coordinates[0], coordinates[1], coordinates[2])
        }
    }
}
