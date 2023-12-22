package aoc2023.day19.aplenty

/** Aplenty Solver */
public class Aplenty(input: String) {
    private val workflows: Map<String, Workflow> =
        input.split("\r?\n\r?\n".toRegex())[0].lines().map { Workflow(it) }.map { Pair(it.id, it) }.toMap()
    private val parts: List<MachinePart> =
        input.split("\r?\n\r?\n".toRegex())[1].trim().lines().map { MachinePart(it) }

    /** First task: TODO */
    fun solution1(): Long = parts.sumOf { processPart(it, "in") }

    /** Second task: TODO */
    fun solution2(): Long = processPart(IntervalMachinePart(1L, 4000L), "in")

    private fun processPart(part: MachinePart, currentWorkflow: String): Long =
        workflows[currentWorkflow]!!.process(part).let {
            when (it) {
                "A" -> part.finalRating()
                "R" -> 0L
                else -> processPart(part, it)
            }
        }

    private fun processPart(part: IntervalMachinePart, currentWorkflow: String): Long {
        var sumOfCombinations: Long = 0L
        for ((newWorkflow, newPart) in workflows[currentWorkflow]!!.process(part)) {
            when (newWorkflow) {
                "A" -> {
                    sumOfCombinations += newPart.combinations()}
                "R" -> continue
                else -> sumOfCombinations += processPart(newPart, newWorkflow)
            }
        }
        return sumOfCombinations
    }
}

private class Workflow(initStr: String) {
    val id: String = Regex("([a-z]+)\\{").find(initStr)!!.groups[1]!!.value
    val steps: List<Step> =
        Regex("\\{(.*)\\}").find(initStr)!!.groups[1]!!.value.split(",").dropLast(1).map {
            Step(it)
        }
    val target: String = Regex(",([a-zAR]+)\\}").find(initStr)!!.groups[1]!!.value

    fun process(part: MachinePart): String {
        for (step in steps) {
            if (step.process(part)) {
                return step.target
            }
        }

        return target
    }

    fun process(part: IntervalMachinePart): List<Pair<String, IntervalMachinePart>> {
        var nextWorkflowsAndParts = mutableListOf<Pair<String, IntervalMachinePart>>()
        var currentPart: IntervalMachinePart? = part
        var newParts: Pair<IntervalMachinePart?, IntervalMachinePart?> = Pair(null, null)

        for (step in steps) {
            currentPart?. let { newParts = step.process(it) } ?: break
            newParts.first?.let {
                nextWorkflowsAndParts.add(Pair(step.target, it))
            }
            currentPart = newParts.second
        }

        currentPart?. let {
            nextWorkflowsAndParts.add(Pair(target, it))
        }

        return nextWorkflowsAndParts.toList()
    }
}

private class Step(initStr: String) {
    val rating: Rating = (Rating from initStr[0])!!
    val comparison: Comparison = (Comparison from initStr[1])!!
    val rhs: Long = Regex("([0-9]+):").find(initStr)!!.groups[1]!!.value.toLong()
    val target: String = Regex(":([a-zAR]+)").find(initStr)!!.groups[1]!!.value

    fun process(part: MachinePart): Boolean = comparison.applyTo(part.ratings[rating.ordinal], rhs)

    fun process(part: IntervalMachinePart): Pair<IntervalMachinePart?, IntervalMachinePart?> =
        comparison.applyTo(part.ratings[rating.ordinal], rhs).let {
            Pair(part.update(rating, it.first), part.update(rating, it.second))
        }
}

private enum class Comparison {
    LESS {
        override fun applyTo(a: Long, b: Long): Boolean = a < b

        override fun applyTo(a: Interval, b: Long): Pair<Interval?, Interval?> =
            if (a.end < b) {
                // println("$a, $b -> 1")
                Pair(a, null)
            } else if (a.start < b && a.end >= b) {
                // println("$a, $b -> 2")
                Pair(Interval(a.start, b-1), Interval(b, a.end))
            } else {
                // println("$a, $b -> 3")
                Pair(null, a)
            }
    },
    GREATER {
        override fun applyTo(a: Long, b: Long): Boolean = a > b

        override fun applyTo(a: Interval, b: Long): Pair<Interval?, Interval?> =
            if (a.start > b) {
                // println("$a, $b -> 1")
                Pair(a, null)
            } else if (a.start <= b && a.end > b) {
                // println("$a, $b -> 2")
                Pair(Interval(b+1, a.end), Interval(a.start, b))
            } else {
                // println("$a, $b -> 3")
                Pair(null, a)
            }
    };

    abstract fun applyTo(a: Long, b: Long): Boolean

    abstract fun applyTo(a: Interval, b: Long): Pair<Interval?, Interval?>

    companion object {
        infix fun from(id: Char): Comparison? =
            when (id) {
                '<' -> LESS
                '>' -> GREATER
                else -> null
            }
    }
}

private enum class Rating {
    X,
    M,
    A,
    S;

    companion object {
        infix fun from(id: Char): Rating? =
            when (id) {
                'x' -> X
                'm' -> M
                'a' -> A
                's' -> S
                else -> null
            }
    }
}

private class MachinePart(initStr: String) {
    val ratings: List<Long> =
        Regex("\\{x=([0-9]+),m=([0-9]+),a=([0-9]+),s=([0-9]+)\\}")
            .find(initStr)!!
            .groups
            .drop(1)
            .map { it!!.value.toLong() }

    fun finalRating(): Long = ratings.sum()
}

private class IntervalMachinePart(val ratings: List<Interval>) {

    constructor(start: Long, end: Long) : this(List(4) { Interval(start, end) })

    fun combinations(): Long = ratings.fold(1) { acc, r -> acc * r.length() }

    fun update(rating: Rating, interval: Interval?): IntervalMachinePart? =
        interval?.let {
            IntervalMachinePart(ratings.toMutableList().let { it[rating.ordinal] = interval; it }.toList())
        }
}

private data class Interval(val start: Long, val end: Long) {

  fun length(): Long = end - start + 1

}
