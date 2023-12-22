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

    // Wire up input connections of conjunction modules and detect output module
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

    /** First task: Simulate 1000 button presses and return the sum of high and low pulses. */
    fun amountOfPulses(): Int {
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

    /**
     * Second task: Calculate the amount of buttom presses until a single low pulse is send to the
     * output module. The network consists of a sub network for each nodes that comes after the
     * broadcaster. These sub networks act as counters and if they reach a certain values they will
     * send a high pulse to the last conjunction before the output module. The counter will reset to
     * zero after that. The output module will recieve a single low pulse if all sub networks send a
     * high pulse to the last conjunction at the same time, i.e. when the counters synchronize. The
     * step when this happens is the least common multiple of the loop lengths.
     */
    fun buttonPressesUntilLowPulse(): Long {
        if (output == null) {
            return -1
        }

        // Reset
        modules.values.forEach { it.reset() }

        // Determine all start pulses from the broadcaster
        val startPulses: List<Pulse> =
            modules["broadcaster"]!!.trigger(Pulse("button", "broadcaster", false))

        // Detect loop length and calculate the least common multiple
        return lcm(startPulses.map { detectLoop(it) })
    }

    /** Calculate the loop length for the sub network started from the given [start] pulse. */
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

        // Detect when we hit a state which we already encounted
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

    /** Return list of pulses which are [high] (or not) to all destination modules. */
    protected fun sendPulse(high: Boolean): List<Pulse> = destinations.map { Pulse(id, it, high) }

    companion object {
        /** Create a specialized module from its string representation in [initStr]. */
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

/** Initial broadcaster module with a given [id] and all module [destinations]. */
private class Broadcaster(id: String, destinations: List<String>) : Module(id, destinations) {

    /** Broadcast the given [pulse] to all destination modules. */
    override fun trigger(pulse: Pulse): List<Pulse> {
        if (pulse.isHigh) highPulses++ else lowPulses++
        return sendPulse(pulse.isHigh)
    }

    /** No-op; nothing to wire up for broadcaster modules. */
    override fun wireUp(sender: String): Unit {}

    /** Broadcaster modules have no state. Always returns zero. */
    override fun state(): Int = 0

    /** Broadcaster modules don't need a state [index]. Return it unchanged. */
    override fun setIndex(index: Int): Int = index
}

/** Flip-Flop module with a given [id] and all module [destinations]. */
private class FlipFlop(id: String, destinations: List<String>) : Module(id, destinations) {

    /** Internal state of the Flip-Flop. */
    private var on: Boolean = false

    /** If the [pulse] is low, toggle the internal state and send new pulses to the destinations. */
    override fun trigger(pulse: Pulse): List<Pulse> =
        if (pulse.isHigh) {
            highPulses++
            listOf<Pulse>()
        } else {
            lowPulses++
            on = !on
            sendPulse(on)
        }

    /** No-op; nothing to wire up for broadcaster modules. */
    override fun wireUp(sender: String): Unit {}

    /** Internal state of the flip-flop shifted by the state index. */
    override fun state(): Int =
        if (on) {
            1 shl idx
        } else {
            0
        }

    /** Set the state [index] and return the next index. */
    override fun setIndex(index: Int): Int {
        idx = index
        return idx + 1
    }
}

/** Conjunction module with a given [id] and all module [destinations]. */
private class Conjunction(id: String, destinations: List<String>) : Module(id, destinations) {

    /** Internal state which stores the last recieved pulses. */
    private val lastPulse: MutableMap<String, Boolean> = mutableMapOf<String, Boolean>()

    /**
     * Store the [pulse] intensity in the internal state. If the last recieved pulses are all high,
     * send low pulses to all destinations. Otherwise send high pulses.
     */
    override fun trigger(pulse: Pulse): List<Pulse> {
        if (pulse.isHigh) highPulses++ else lowPulses++
        lastPulse[pulse.origin] = pulse.isHigh
        return sendPulse(!lastPulse.values.all { it })
    }

    /** Wire up the conjunction with a given [sender] module. */
    override fun wireUp(sender: String): Unit {
        lastPulse[sender] = false
    }

    /** Interpret the internal state as a binary number and return it shifted by the state index. */
    override fun state(): Int {
        return lastPulse.values.foldIndexed(0) { i, acc, on ->
            if (on) acc + (1 shl i) else acc
        } shl idx
    }

    /** Set the state [index] and return the next index. */
    override fun setIndex(index: Int): Int {
        idx = index
        return idx + lastPulse.size
    }
}

/** Output module with a given [id]. */
private class Output(id: String) : Module(id, listOf<String>()) {

    /** Just count the given [pulse]. */
    override fun trigger(pulse: Pulse): List<Pulse> {
        if (pulse.isHigh) highPulses++ else lowPulses++
        return listOf<Pulse>()
    }

    /** No-op; nothing to wire up for broadcaster modules. */
    override fun wireUp(sender: String): Unit {}

    /** Output modules have no state. Always returns zero. */
    override fun state(): Int = 0

    /** Output modules don't need a state [index]. Return it unchanged. */
    override fun setIndex(index: Int): Int = index
}

/** Pulse represented by an [origin] and a [destination] ID, and an intensity flag [isHigh]. */
private data class Pulse(val origin: String, val destination: String, val isHigh: Boolean)

/** Calculates the greatest common divisor between [a] and [b]. */
private fun gcd(a: Long, b: Long): Long = if (b == 0L) a else gcd(b, a % b)

/** Calculates the least common multiple between [a] and [b]. */
private fun lcm(a: Long, b: Long): Long = a * (b / gcd(a, b))

/** Calculates the least common multiple between all values in [vals]. */
private fun lcm(vals: List<Long>): Long = vals.reduce { acc, v -> lcm(acc, v) }
