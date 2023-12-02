package aoc2023.day01

// Import solution and CLI argument parser
import aoc2023.day01.trebuchet.Trebuchet
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 01: Trebuchet") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: Trebuchet = Trebuchet(input.readText(Charsets.UTF_8))

        val result_1: Int = app.sumOfCalibrationValues()
        println("Sum of calibration values: $result_1")

        val result_2: Int = app.sumOfLiteralCalibrationValues()
        println("Sum of calibration values including digit strings: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
