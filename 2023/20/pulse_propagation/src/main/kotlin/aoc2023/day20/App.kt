package aoc2023.day20

// Import solution and CLI argument parser
import aoc2023.day20.pulsePropagation.PulsePropagation
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 20: Pulse Propagation") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: PulsePropagation = PulsePropagation(input.readText(Charsets.UTF_8))

        val result_1: Int = app.amountOfPulses()
        println("Total amount of pulses after 1000 button presses: $result_1")

        val result_2: Long = app.buttonPressesUntilLowPulse()
        println("Amount of needed button presses until output recieves low pulse: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
