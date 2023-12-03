package aoc2023.day03

// Import solution and CLI argument parser
import aoc2023.day03.gearRatios.GearRatios
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 03: Gear Ratios") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: GearRatios = GearRatios(input.readText(Charsets.UTF_8))

        val result_1: Int = app.sumOfPartNumbers()
        println("Sum of valid part numbers: $result_1")

        val result_2: Int = app.sumOfGearRatios()
        println("Sum of gear ratios: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
