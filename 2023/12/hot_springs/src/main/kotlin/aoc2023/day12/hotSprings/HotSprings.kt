package aoc2023.day12.hotSprings

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.runBlocking

/** Parallel map of a generic list to [f] using coroutines. */
suspend fun <A, B> List<A>.pmap(f: suspend (A) -> B): List<B> = coroutineScope {
    map { async { f(it) } }.awaitAll()
}

/** Hot Springs Solver */
public class HotSprings(input: String) {
    private val lines: List<String> = input.lines()

    /** Lists of springs. */
    private val springs: List<SpringCollection> = lines.map { SpringCollection(it.split(" ")) }

    /** Calculate the sum of all spring configurations considering the given [multiplier]. */
    fun sumOfSpringConfigurations(multiplier: Int): Long =
        runBlocking(Dispatchers.Default) {
            springs
                .pmap {
                    it *= multiplier
                    it.springConfigurations()
                }
                .sum()
        }
}

/** Class to store a set of strings initialized from [initStr]. */
private class SpringCollection(initStr: List<String>) {
    /** The springs. */
    val originalSprings: String = initStr[0]
    var springs: String = originalSprings

    /** The damage reports. */
    val originalDamageReports: List<Int> = initStr[1].split(",").map { it.toInt() }
    var damageReports: MutableList<Int> = originalDamageReports.toMutableList()

    /** Groups consisting of damaged and unknown springs. */
    var groups: List<String> = springs.split('.').filter { it.isNotBlank() }

    /** Cache for memoization. */
    val cache: MutableMap<Int, Long> = mutableMapOf()

    /** Multiply the damage reports and the spring groups by the given [multiplier]. */
    operator fun timesAssign(multiplier: Int): Unit {
        damageReports = originalDamageReports.toMutableList()
        springs = originalSprings

        for (i in 0 ..< multiplier - 1) {
            springs += '?' + originalSprings
            damageReports.addAll(originalDamageReports)
        }

        groups = springs.split('.').filter { it.isNotBlank() }
    }

    /**
     * Calculate the amount of spring configurations that match the damage reports. We start at the
     * group with the given [groupIdx] and the current [position] in that group. From there we try
     * to fit the damage report with the given [reportIdx] into that group. After doing that we call
     * this function recursively to fit the rest of the damage reports. At the end we return the
     * counted amount of spring configurations.
     */
    fun springConfigurations(reportIdx: Int = 0, groupIdx: Int = 0, position: Int = 0): Long {

        // If we already calculated a certain branch, return its memoized value.
        val hashValue = hash(reportIdx, groupIdx, position)
        cache.get(hashValue)?.let {
            return it
        }

        // Lambda to cache a value and return it
        val cacheValueAndReturn: (Long) -> Long = { value ->
            cache[hashValue] = value
            value
        }

        var count: Long = 0
        var currentIdx = position

        // No damage reports left. Return 1 if there are no damaged springs in the row left.
        if (reportIdx >= damageReports.size) {
            for (i in groupIdx ..< groups.size) {
                for (j in currentIdx ..< groups[i].length) {
                    if (groups[i][j] == '#') {
                        return cacheValueAndReturn(0)
                    }
                }
                currentIdx = 0
            }
            return cacheValueAndReturn(1)
        }

        // Iterate over all groups
        for (i in groupIdx ..< groups.size) {
            // Iterate through the group as long as the damage report fits inside
            while (groups[i].length - currentIdx >= damageReports[reportIdx]) {
                val nextIdx = currentIdx + damageReports[reportIdx]
                if (nextIdx == groups[i].length || groups[i][nextIdx] == '?') {
                    // Insert damage report and call function recursively for the next one
                    count += springConfigurations(reportIdx + 1, i, nextIdx + 1)
                }

                // Return if we moved over a damaged spring
                if (groups[i][currentIdx] == '?') {
                    currentIdx++
                } else {
                    return cacheValueAndReturn(count)
                }
            }

            // Return if we moved over a damaged spring
            if (currentIdx < groups[i].length) {
                if (groups[i].substring(currentIdx ..< groups[i].length).contains('#')) {
                    return cacheValueAndReturn(count)
                }
            }
            currentIdx = 0
        }

        return cacheValueAndReturn(count)
    }

    /**
     * Calculate a hash value for the current [reportIdx], [groupIdx] and the [position] in the
     * group. The three values are not allowed to be larger than 1023 each which won't happen for
     * our purposes.
     */
    private fun hash(reportIdx: Int, groupIdx: Int, position: Int): Int =
        reportIdx * (1 shl 20) + groupIdx * (1 shl 10) + position
}
