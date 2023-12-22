package aoc2023.day20.pulsePropagation

import java.util.LinkedList
import java.util.Queue

/** Pulse Propagation Solver */
public class PulsePropagation(input: String) {

    /** Map of modules and their IDs. */
    private val modules: MutableMap<String, Module> =
        input.lines().map { (Module from it)!! }.map { Pair(it.id, it) }.toMap().toMutableMap()

    /** Output module ID. */
    private var output: String? = null

    // Initialize
    init {
        for (origin in modules) {
            for (destination in origin.value.destinations) {
                if (modules.containsKey(destination)) {
                    modules[destination]!!.wireUp(origin.key)
                } else {
                    output = destination
                }
            }
        }

        output?.let { modules[it] = (Output(it)) }
    }

    /** First task: TODO */
    fun solution1(): Int {
        val queue: Queue<Pulse> = LinkedList()

        // Reset
        modules.values.forEach { it.reset() }

        for (i in 1..1000) {
            queue.add(Pulse("button", "broadcaster", false))

            while (queue.size > 0) {
                val pulse = queue.remove()
                if (modules.containsKey(pulse.destination)) {
                    queue.addAll(modules[pulse.destination]!!.trigger(pulse))
                }
            }
        }

        return modules.values.sumOf { it.lowPulses } * modules.values.sumOf { it.highPulses }
    }

    /** Second task: TODO */
    fun solution2(): Long {
        if (output == null) {
            return -1
        }

        // Reset
        modules.values.forEach { it.reset() }

        val startPulses: List<Pulse> =
            modules["broadcaster"]!!.trigger(Pulse("button", "broadcaster", false))
        return lcm(startPulses.map { detectLoop(it) })
    }

    private fun detectLoop(start: Pulse): Long {
        val queue: Queue<Pulse> = LinkedList()

        // Create set of sub modules
        val subModules: MutableSet<String> = mutableSetOf()
        val subQueue: Queue<String> = LinkedList()
        subQueue.add(start.destination)
        while (subQueue.size > 0) {
            val subModule = subQueue.remove()
            subModules.add(subModule)
            modules[subModule]!!.destinations.forEach {
                if (!subModules.contains(it)) {
                    subQueue.add(it)
                }
            }
        }

        // Set indices for state calculation
        var currentIdx = 0
        subModules.forEach { currentIdx = modules[it]!!.setIndex(currentIdx) }

        val states: MutableList<Int> = mutableListOf(0)
        var currentState: Int = subModules.fold(0) { acc, id -> acc + modules[id]!!.state() }
        while (!states.contains(currentState)) {
            queue.add(start)
            while (queue.size > 0) {
                val pulse = queue.remove()
                if (modules.containsKey(pulse.destination)) {
                    queue.addAll(modules[pulse.destination]!!.trigger(pulse))
                }
            }

            states.add(currentState)
            currentState = subModules.fold(0) { acc, id -> acc + modules[id]!!.state() }
        }

        return states.size.toLong() - 1L
    }
}

/** Abstract module class initialized by its [id] and its pulse [destinations]. */
private abstract class Module(val id: String, val destinations: List<String>) {

    /** Amount of low pulses recieved by this module. */
    var lowPulses: Int = 0
    /** Amount of high pulses recieved by this module. */
    var highPulses: Int = 0
    /** Index for a state calculation. */
    var idx: Int = 0

    /** Trigger this module with a [pulse]. */
    abstract fun trigger(pulse: Pulse): List<Pulse>

    /** Wire up this module as the destination of some other [sender] module. */
    abstract fun wireUp(sender: String): Unit

    /** Return the state of this module. */
    abstract fun state(): Int

    /** Set the state [index]. */
    abstract fun setIndex(index: Int): Int

    /** Reset pulse counters and state index. */
    fun reset(): Unit {
        lowPulses = 0
        highPulses = 0
        idx = 0
    }

    /**  */
    protected fun sendPulse(isHigh: Boolean): List<Pulse> =
        destinations.map { Pulse(id, it, isHigh) }

    companion object {
        infix fun from(initStr: String): Module? {
            val nameAndDestinations: List<String> = initStr.split(" -> ")
            val destinations: List<String> = nameAndDestinations[1].split(", ")
            if (nameAndDestinations[0] == "broadcaster") {
                return Broadcaster(nameAndDestinations[0], destinations)
            }

            val type: Char = nameAndDestinations[0][0]
            val id: String = nameAndDestinations[0].substring(1)

            return when (type) {
                '%' -> FlipFlop(id, destinations)
                '&' -> Conjunction(id, destinations)
                else -> null
            }
        }
    }
}

private class Broadcaster(id: String, destinations: List<String>) : Module(id, destinations) {

    override fun trigger(pulse: Pulse): List<Pulse> {
        if (pulse.isHigh) highPulses++ else lowPulses++
        return sendPulse(pulse.isHigh)
    }

    override fun wireUp(sender: String): Unit {}

    override fun state(): Int = 0

    override fun setIndex(index: Int): Int = index
}

private class FlipFlop(id: String, destinations: List<String>) : Module(id, destinations) {
    private var on: Boolean = false

    override fun trigger(pulse: Pulse): List<Pulse> =
        if (pulse.isHigh) {
            highPulses++
            listOf<Pulse>()
        } else {
            lowPulses++
            on = !on
            sendPulse(on)
        }

    override fun wireUp(sender: String): Unit {}

    override fun state(): Int =
        if (on) {
            1 shl idx
        } else {
            0
        }

    override fun setIndex(index: Int): Int {
        idx = index
        return idx + 1
    }
}

private class Conjunction(id: String, destinations: List<String>) : Module(id, destinations) {
    private val lastPulse: MutableMap<String, Boolean> = mutableMapOf<String, Boolean>()

    override fun trigger(pulse: Pulse): List<Pulse> {
        if (pulse.isHigh) highPulses++ else lowPulses++
        lastPulse[pulse.origin] = pulse.isHigh
        return sendPulse(!lastPulse.values.all { it })
    }

    override fun wireUp(sender: String): Unit {
        lastPulse[sender] = false
    }

    override fun state(): Int {
        return lastPulse.values.foldIndexed(0) { i, acc, on ->
            if (on) acc + (1 shl i) else acc
        } shl idx
    }

    override fun setIndex(index: Int): Int {
        idx = index
        return idx + lastPulse.size
    }
}

private class Output(id: String) : Module(id, listOf<String>()) {

    override fun trigger(pulse: Pulse): List<Pulse> {
        if (pulse.isHigh) highPulses++ else lowPulses++
        return listOf<Pulse>()
    }

    override fun wireUp(sender: String): Unit {}

    override fun state(): Int = 0

    override fun setIndex(index: Int): Int = index
}

private data class Pulse(val origin: String, val destination: String, val isHigh: Boolean)

/** Calculates the greatest common divisor between [a] and [b]. */
private fun gcd(a: Long, b: Long): Long = if (b == 0L) a else gcd(b, a % b)

/** Calculates the least common multiple between [a] and [b]. */
private fun lcm(a: Long, b: Long): Long = a * (b / gcd(a, b))

/** Calculates the least common multiple between all values in [vals]. */
private fun lcm(vals: List<Long>): Long = vals.reduce { acc, v -> lcm(acc, v) }
