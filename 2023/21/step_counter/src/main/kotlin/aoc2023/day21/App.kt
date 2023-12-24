package aoc2023.day21

// Import solution and CLI argument parser
import aoc2023.day21.stepCounter.StepCounter
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.options.default
import com.github.ajalt.clikt.parameters.options.option
import com.github.ajalt.clikt.parameters.types.file
import com.github.ajalt.clikt.parameters.types.long

class App : CliktCommand(help = "Day 21: Step Counter") {
    val input by argument().file(mustExist = true)
    val steps: Long by option("-s", "--steps", help = "Amount of steps").long().default(64)

    override fun run() {
        val app: StepCounter = StepCounter(input.readText(Charsets.UTF_8))

        val result_1: Int = app.solution1(steps, infinite = false)
        println("1. Solution: $result_1")

        val result_2: Int = app.solution1(steps, infinite = false)
        println("2. Solution: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
