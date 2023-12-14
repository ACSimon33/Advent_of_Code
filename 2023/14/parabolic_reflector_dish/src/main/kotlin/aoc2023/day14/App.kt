package aoc2023.day14

// Import solution and CLI argument parser
import aoc2023.day14.parabolicReflectorDish.ParabolicReflectorDish
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.options.default
import com.github.ajalt.clikt.parameters.options.option
import com.github.ajalt.clikt.parameters.types.file
import com.github.ajalt.clikt.parameters.types.long

class App : CliktCommand(help = "Day 14: Parabolic Reflector Dish") {
    val input by argument().file(mustExist = true)
    val cycles: Long by option("-c", "--cycles", help = "NUmber of cycles").long().default(1L)

    override fun run() {
        val app: ParabolicReflectorDish = ParabolicReflectorDish(input.readText(Charsets.UTF_8))

        val result_1: Int = app.beamLoad()
        println("Initial load on the northern support beam: $result_1")

        val result_2: Int = app.beamLoadAfter(cycles)
        println("Total load on the northern support beam after $cycles cycles: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
