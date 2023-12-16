package aoc2023.day16.theFloorWillBeLava

/** The Floor Will Be Lava Solver */
public class TheFloorWillBeLava(input: String) {
    private val tiles: List<List<Tile>> = input.lines().map { it.map { c -> (Tile from c)!! } }
    val rows: Int = tiles.size
    val cols: Int = tiles[0].size

    /**
     * First task: Travel with the light beam starting in the top-left corner and count the amount
     * of energized tiles.
     */
    fun amountOfEnergizedTiles(): Int {
        travel(0, 0, Direction.EAST)
        return tiles.flatten().count { it.isEnergized() }
    }

    /**
     * Second task: Create a starting configuration for each border tile and start a light beam from
     * all of these directions. Return the maximum energy possible that can be achived by a single
     * light beam.
     */
    fun maximumAmountOfEnergizedTiles(): Int {
        val startingConfigurations = mutableListOf<Triple<Int, Int, Direction>>()
        for (row in 0 ..< rows) {
            startingConfigurations.add(Triple(row, 0, Direction.EAST))
            startingConfigurations.add(Triple(row, cols - 1, Direction.WEST))
        }
        for (col in 0 ..< cols) {
            startingConfigurations.add(Triple(0, col, Direction.SOUTH))
            startingConfigurations.add(Triple(rows - 1, col, Direction.NORTH))
        }

        return startingConfigurations
            .map {
                travel(it.first, it.second, it.third)
                tiles.flatten().count { tile -> tile.isEnergized().also { tile.reset() } }
            }
            .max()
    }

    /**
     * Pass the light beam with a direction [travelDir] through the tile at ([row], [col]). Repeat
     * the process for all new emerging light beams.
     */
    private fun travel(row: Int, col: Int, travelDir: Direction): Unit {
        if (row < 0 || row >= rows || col < 0 || col >= cols) {
            return
        }

        for (newDir in tiles[row][col].traverseLightBeam(travelDir)) {
            when (newDir) {
                Direction.NORTH -> travel(row - 1, col, newDir)
                Direction.EAST -> travel(row, col + 1, newDir)
                Direction.SOUTH -> travel(row + 1, col, newDir)
                Direction.WEST -> travel(row, col - 1, newDir)
            }
        }
    }
}

/** Abstract tile class which can handle an incoming light beam. */
private abstract class Tile {

    /** Keep track of the direction of light beam that pass through this tile. */
    private val energized: MutableList<Boolean> = mutableListOf(false, false, false, false)

    /** Traverse a light beam traveling in [travelDir]. Returns a list of exiting light beams. */
    fun traverseLightBeam(travelDir: Direction): List<Direction> =
        if (energized[travelDir.ordinal]) {
            listOf<Direction>()
        } else {
            energized[travelDir.ordinal] = true
            getNewLightBeams(travelDir)
        }

    /** Return true if this tile is traversed by any light beam. */
    fun isEnergized(): Boolean = energized.any { it }

    /** Reset the energy map. */
    fun reset(): Unit = energized.fill(false)

    /** Function that calculates the directions of exiting light beams given the [travelDir]. */
    abstract fun getNewLightBeams(travelDir: Direction): List<Direction>

    companion object {
        /** Create a tile from its char [id]. */
        infix fun from(id: Char): Tile? =
            when (id) {
                '.' -> EmptySpace()
                '/' -> RightMirror()
                '\\' -> LeftMirror()
                '-' -> HorizontalSplitter()
                '|' -> VerticalSplitter()
                else -> null
            }
    }
}

/** Tile sprecialization for empty space. */
private class EmptySpace : Tile() {

    /** Emty space doesn't affect the light beam. Return the [travelDir] unchanged. */
    override fun getNewLightBeams(travelDir: Direction): List<Direction> = listOf(travelDir)
}

/** Tile sprecialization for a right-sided mirror. */
private class RightMirror : Tile() {

    /** Reflect the light beam in [travelDir] of the mirror and return the new direction. */
    override fun getNewLightBeams(travelDir: Direction): List<Direction> {
        return when (travelDir) {
            Direction.NORTH -> listOf(Direction.EAST)
            Direction.EAST -> listOf(Direction.NORTH)
            Direction.SOUTH -> listOf(Direction.WEST)
            Direction.WEST -> listOf(Direction.SOUTH)
        }
    }
}

/** Tile sprecialization for a left-sided mirror. */
private class LeftMirror : Tile() {

    /** Reflect the light beam in [travelDir] of the mirror and return the new direction. */
    override fun getNewLightBeams(travelDir: Direction): List<Direction> {
        return when (travelDir) {
            Direction.NORTH -> listOf(Direction.WEST)
            Direction.EAST -> listOf(Direction.SOUTH)
            Direction.SOUTH -> listOf(Direction.EAST)
            Direction.WEST -> listOf(Direction.NORTH)
        }
    }
}

/** Tile sprecialization for a horizontal splitter. */
private class HorizontalSplitter : Tile() {

    /**
     * If the [travelDir] is horizontal, return it unchanged. If it's vertical, split it into two
     * new travel directions going horizontally (WEST, EAST).
     */
    override fun getNewLightBeams(travelDir: Direction): List<Direction> {
        return when (travelDir) {
            Direction.NORTH,
            Direction.SOUTH -> listOf(Direction.WEST, Direction.EAST)
            else -> listOf(travelDir)
        }
    }
}

/** Tile sprecialization for a vertical splitter. */
private class VerticalSplitter : Tile() {

    /**
     * If the [travelDir] is vertically, return it unchanged. If it's horizontal, split it into two
     * new travel directions going vertically (NORTH, SOUTH).
     */
    override fun getNewLightBeams(travelDir: Direction): List<Direction> {
        return when (travelDir) {
            Direction.WEST,
            Direction.EAST -> listOf(Direction.NORTH, Direction.SOUTH)
            else -> listOf(travelDir)
        }
    }
}

/** Direction of the light beam. */
private enum class Direction {
    NORTH,
    EAST,
    SOUTH,
    WEST
}
