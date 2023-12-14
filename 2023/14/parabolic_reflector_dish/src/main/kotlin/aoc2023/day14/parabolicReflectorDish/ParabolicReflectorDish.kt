package aoc2023.day14.parabolicReflectorDish

/** Parabolic Reflector Dish Solver */
public class ParabolicReflectorDish(input: String) {
    private val dish = ReflectorDish(input)

    /** First task: Tilt the platform to the north and calculate the beam load. */
    fun beamLoad(): Int {
        dish.tilt(Direction.NORTH)
        return dish.load(Direction.NORTH)
    }

    /**
     * Second task: Rotate the platform to the north, west, south, and each a given amount of
     * [cycles]. Calculate the beam load after all those cycles. We wuick return as soon as we reach
     * a state which we already encountered before.
     */
    fun beamLoadAfter(cycles: Long): Int {
        val loads = mutableMapOf(Pair(dish.toString(), Pair(0L, dish.load(Direction.NORTH))))
        for (i in 1L .. cycles) {
            dish.tilt(Direction.NORTH)
            dish.tilt(Direction.WEST)
            dish.tilt(Direction.SOUTH)
            dish.tilt(Direction.EAST)

            // Quick return if the current state was already reached earlier
            val str: String = dish.toString()
            loads.get(str)?.let {
                val idx: Long = it.first + (cycles - i) % (i - it.first)
                return loads.values.filter { it.first == idx }[0].second
            }

            loads[dish.toString()] = Pair(i, dish.load(Direction.NORTH))
        }

        return dish.load(Direction.NORTH)
    }
}

/** Enumeration of rock types. */
private enum class Rock {
    None,
    Cube,
    Round;

    companion object {
        /** Create a rock from its char [id]. */
        infix fun from(id: Char): Rock? =
            when (id) {
                '.' -> None
                '#' -> Cube
                'O' -> Round
                else -> null
            }
    }
}

/** Platform tilt directions. */
private enum class Direction {
    NORTH,
    EAST,
    SOUTH,
    WEST
}

/** Class which handles the tilting of the reflector dish and load calculations. */
private class ReflectorDish(initStr: String) {
    private val controlRocks: List<MutableList<Rock>> =
        initStr.lines().map { it.map { c -> (Rock from c)!! }.toMutableList()}

    /** Tilt the platform in the given [direction]. All round rocks will roll as far as they can. */
    fun tilt(direction: Direction) : Unit {
        var changed: Boolean

        if (direction == Direction.NORTH) {
            do {
                changed = false
                for (i in 0 ..< controlRocks.size - 1) {
                    for (j in 0 ..< controlRocks[i].size) {
                        if (controlRocks[i][j] == Rock.None && controlRocks[i+1][j] == Rock.Round) {
                            controlRocks[i][j] = Rock.Round
                            controlRocks[i+1][j] = Rock.None
                            changed = true
                        }
                    }
                }
            } while (changed)
        } else if (direction == Direction.EAST) {
            do {
                changed = false
                for (i in 0 ..< controlRocks.size) {
                    for (j in (controlRocks[i].size - 1) downTo 1) {
                        if (controlRocks[i][j] == Rock.None && controlRocks[i][j-1] == Rock.Round) {
                            controlRocks[i][j] = Rock.Round
                            controlRocks[i][j-1] = Rock.None
                            changed = true
                        }
                    }
                }
            } while (changed)
        } else if (direction == Direction.SOUTH) {
            do {
                changed = false
                for (i in (controlRocks.size - 1) downTo 1) {
                    for (j in 0 ..< controlRocks[i].size) {
                        if (controlRocks[i][j] == Rock.None && controlRocks[i-1][j] == Rock.Round) {
                            controlRocks[i][j] = Rock.Round
                            controlRocks[i-1][j] = Rock.None
                            changed = true
                        }
                    }
                }
            } while (changed)
        } else if (direction == Direction.WEST) {
            do {
                changed = false
                for (i in 0 ..< controlRocks.size) {
                    for (j in 0 ..< controlRocks[i].size - 1) {
                        if (controlRocks[i][j] == Rock.None && controlRocks[i][j+1] == Rock.Round) {
                            controlRocks[i][j] = Rock.Round
                            controlRocks[i][j+1] = Rock.None
                            changed = true
                        }
                    }
                }
            } while (changed)
        }
    }

    /** Calculate the load on the support beam in the given [direction]. */
    fun load(direction: Direction): Int {
        var l: Int = 0
        if (direction == Direction.NORTH) {
            for (i in 0 ..< controlRocks.size) {
                l += controlRocks[i].count { it == Rock.Round } * (controlRocks.size - i)
            }
        } else if (direction == Direction.EAST) {
            for (j in 0 ..< controlRocks[0].size) {
                l += controlRocks.count { it[j] == Rock.Round } * (j + 1)
            }
        } else if (direction == Direction.SOUTH) {
            for (i in 0 ..< controlRocks.size) {
                l += controlRocks[i].count { it == Rock.Round } * (i + 1)
            }
        } else if (direction == Direction.WEST) {
            for (j in 0 ..< controlRocks[0].size) {
                l += controlRocks.count { it[j] == Rock.Round } * (controlRocks[0].size - j)
            }
        }

        return l
    }

    /** Create a string regresentation of the platform. */
    override fun toString() : String {
        var str: String = ""
        for (i in 0 ..< controlRocks.size) {
            for (j in 0 ..< controlRocks[i].size) {
                when (controlRocks[i][j]) {
                    Rock.None -> str += '.'
                    Rock.Cube -> str += '#'
                    Rock.Round -> str += 'O'
                }
            }
            str += '\n'
        }
        return str
    }
}
