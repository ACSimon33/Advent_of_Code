package aoc2023.day02.cubeConundrum

/** Cube Conundrum Solver */
public class CubeConundrum(input: String) {
    val games: List<Game> = input.lines().map { Game(it) }

    /**
     * First task: Filter all games by checking if the specific draw of 12 red cubes, 13 green cubes
     * and 14 blue cubes is possible and sum up their ids.
     */
    fun sumOfPossibleGameIds(): Int = games.filter { it.isDrawPossible(12, 13, 14) }.sumOf { it.id }

    /** Second task: Sum up the powers of all games */
    fun sumOfGamePowers(): Int = games.sumOf { it.power }
}

/** Cube Game class */
class Game(gameStr: String) {
    val id: Int = Regex("Game ([0-9]*):").find(gameStr)!!.groups[1]!!.value.toInt()

    /** Amount of red cubes */
    private val red: List<Int> =
        gameStr.split(";").map {
            Regex("([0-9]*) red").find(it)?.let { it.groups[1]!!.value.toInt() } ?: 0
        }

    /** Amount of green cubes */
    private val green: List<Int> =
        gameStr.split(";").map {
            Regex("([0-9]*) green").find(it)?.let { it.groups[1]!!.value.toInt() } ?: 0
        }

    /** Amount of blue cubes */
    private val blue: List<Int> =
        gameStr.split(";").map {
            Regex("([0-9]*) blue").find(it)?.let { it.groups[1]!!.value.toInt() } ?: 0
        }

    /** Game's power (product of maximum draws) */
    val power: Int
        get() = red.max() * green.max() * blue.max()

    /**
     * Check whether a specific draw consisting of [r] red cubes, [g] green cubes and [b] blue cubes
     * would've been possible in the current game.
     */
    fun isDrawPossible(r: Int, g: Int, b: Int): Boolean =
        red.max() <= r && green.max() <= g && blue.max() <= b
}
