package aoc2023.day08.hauntedWasteland

import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking

/** Parallel map of a generic list to [f] using coroutines. */
suspend fun <A, B> List<A>.pmap(f: suspend (A) -> B): List<B> = coroutineScope {
    map { async { f(it) } }.awaitAll()
}

/** Haunted Wasteland Solver */
public class HauntedWasteland(val input: String) {
    private val lr: String = Regex("([LR]*)\n\n").find(input)!!.groups[1]!!.value
    private val nodes: Map<String, Node> =
        Regex("([A-Z0-9]{3}) = \\(([A-Z0-9]{3}), ([A-Z0-9]{3})\\)")
            .findAll(input)
            .map { Pair(it.groups[1]!!.value, Node(it.groups[2]!!.value, it.groups[3]!!.value)) }
            .toMap()

    /**
     * First task: Calculate the distance from 'AAA' to 'ZZZ'. We are assuming here that there is
     * no other **Z node in the loop.
     */
    fun stepsOfSinglePath(): Int = detectLoop("AAA")

    /**
     * Second task: Calculate the least common multiple between all distances from '**A' to '**Z'.
     * We assume here that the amount of **A to **Z is the same as the loop length **Z to **Z. Also
     * the loop needs to be fixed which means we are reaching **Z always on the same instruction.
     */
    fun stepsOfAllPaths(): Long = runBlocking(Dispatchers.Default) {
        lcm(nodes.keys.filter { it.endsWith('A') }.toList().pmap { detectLoop(it).toLong() })
    }

    /** Calculate the loop length from the [startNode] to the end node '**Z'. */
    private fun detectLoop(startNode: String): Int {
        var steps: Int = 0
        var currentNode: String = startNode

        while (!currentNode.endsWith('Z')) {
            if (lr[steps % lr.length] == 'L') {
                currentNode = nodes[currentNode]!!.left
            } else {
                currentNode = nodes[currentNode]!!.right
            }
            steps++
        }

        return steps
    }
}

/** Data class for a node with a [left] and a [right] successor node. */
private data class Node(val left: String, val right: String)

/** Calculates the greatest common divisor between [a] and [b]. */
private fun gcd(a: Long, b: Long): Long = if (b == 0L) a else gcd(b, a % b)

/** Calculates the least common multiple between [a] and [b]. */
private fun lcm(a: Long, b: Long): Long = a * (b / gcd(a, b))

/** Calculates the least common multiple between all values in [vals]. */
private fun lcm(vals: List<Long>): Long = vals.reduce { acc, v -> lcm(acc, v) }
