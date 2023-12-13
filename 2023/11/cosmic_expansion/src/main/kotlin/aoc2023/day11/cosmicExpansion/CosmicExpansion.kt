package aoc2023.day11.cosmicExpansion

/** Cosmic Expansion Solver */
public class CosmicExpansion(input: String) {
    private val space: List<String> = input.lines()

    /** List of all galaxies. */
    private val galaxies: List<Galaxy> =
        space
            .mapIndexed { i, row ->
                row.mapIndexed { j, space -> Pair(Galaxy(i, j), space) }
                    .filter { it.second == '#' }
                    .map { it.first }
            }
            .flatten()

    /** List of empty rows in the grid. */
    private val emptyRows: List<Int> =
        (0 ..< space.size).filter { i -> space[i].none { it == '#' } }

    /** List of empty columns in the grid. */
    private val emptyCols: List<Int> =
        (0 ..< space[0].length).filter { j -> space.none { it[j] == '#' } }

    /**
     * First task: Calculate the sum of distances between all pairs of galaxies considering the
     * given [expansion] multiplier.
     */
    fun sumOfGalixyDistances(expansion: Long): Long {
        var distanceSum: Long = 0
        for (i in 0 ..< galaxies.size) {
            for (j in i + 1 ..< galaxies.size) {
                distanceSum += galaxies[i].distance(galaxies[j], emptyRows, emptyCols, expansion)
            }
        }

        return distanceSum
    }
}

/** Class to store a galaxy position ([row], [col]) in the grid and provide a distance measure. */
private data class Galaxy(val row: Int, val col: Int) {

    /**
     * Calculate the distances between this galaxy and an [other] given the lists of [emptyRows] and
     * [emptyCols] as well as the [expansion] multiplier.
     */
    fun distance(other: Galaxy, emptyRows: List<Int>, emptyCols: List<Int>, expansion: Long): Long {
        val rows: IntArray = intArrayOf(row, other.row).also { it.sort() }
        val cols: IntArray = intArrayOf(col, other.col).also { it.sort() }

        var dist: Long = (rows[1] - rows[0] + cols[1] - cols[0]).toLong()
        dist += (rows[0]..rows[1]).count { emptyRows.contains(it) } * (expansion - 1)
        dist += (cols[0]..cols[1]).count { emptyCols.contains(it) } * (expansion - 1)

        return dist
    }
}
