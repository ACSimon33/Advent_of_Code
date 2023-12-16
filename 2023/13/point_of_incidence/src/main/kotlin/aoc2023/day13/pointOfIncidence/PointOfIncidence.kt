package aoc2023.day13.pointOfIncidence

import kotlin.math.min

/** Point of Incidence Solver */
public class PointOfIncidence(input: String) {
    private val valleys: List<Valley> = input.split("\r?\n\r?\n".toRegex()).map { Valley(it) }

    /**
     * Calculate a reflection summary by summing over all row reflection indices times 100 and all
     * column reflection indices. The amount of [smudges] that the mirror has is given.
     */
    fun reflectionSummary(smudges: Int): Int =
        valleys.sumOf { 100 * it.rowReflectionIndex(smudges) + it.columnReflectionIndex(smudges) }
}

/** Class which holds a valley pattern of ash and rocks. */
private class Valley(initStr: String) {
    val pattern: List<List<Ground>> = initStr.lines().map { it.map { c -> (Ground from c)!! } }

    /**
     * Find a row reflection under the condition that the mirror has a given number of [smudges].
     * Return the amount of rows before the reflection line.
     */
    fun rowReflectionIndex(smudges: Int): Int {
        val lastRow: Int = pattern.size - 1

        for (row in 0 ..< lastRow) {
            val nextRow: Int = row + 1
            val distanceToEdge = min(lastRow - nextRow, row)
            if ((0..distanceToEdge).sumOf { compareRows(row - it, nextRow + it) } == smudges) {
                return nextRow
            }
        }

        return 0
    }

    /**
     * Find a column reflection under the condition that the mirror has a given number of [smudges].
     * Return the amount of column before the reflection line.
     */
    fun columnReflectionIndex(smudges: Int): Int {
        val lastCol: Int = pattern[0].size - 1

        for (col in 0 ..< lastCol) {
            val nextCol: Int = col + 1
            val distanceToEdge = min(lastCol - nextCol, col)
            if ((0..distanceToEdge).sumOf { compareColumns(col - it, nextCol + it) } == smudges) {
                return nextCol
            }
        }

        return 0
    }

    /** Calculate the number of differences between two rows: [row1] and [row2]. */
    private fun compareRows(row1: Int, row2: Int): Int =
        pattern[row1].zip(pattern[row2]).count { (g1, g2) -> g1 != g2 }

    /** Calculate the number of differences between two columns: [col1] and [col2]. */
    private fun compareColumns(col1: Int, col2: Int): Int = pattern.count { it[col1] != it[col2] }
}

/** Enum for different ground types (ash or rock). */
private enum class Ground {
    Ash,
    Rock;

    companion object {
        /** Create a ground type from its char [id]. */
        infix fun from(id: Char): Ground? =
            when (id) {
                '.' -> Ash
                '#' -> Rock
                else -> null
            }
    }
}
