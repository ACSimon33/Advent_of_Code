package aoc2023.day24

// Import solution and CLI argument parser
import aoc2023.day24.neverTellMeTheOdds.NeverTellMeTheOdds
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.options.default
import com.github.ajalt.clikt.parameters.options.option
import com.github.ajalt.clikt.parameters.types.file
import com.github.ajalt.clikt.parameters.types.double

class App : CliktCommand(help = "Day 24: Never Tell Me The Odds") {
    val input by argument().file(mustExist = true)
    val minVal: Double by option("-l", "--lower", help = "Lower bound").double().default(7.0)
    val maxVal: Double by option("-u", "--upper", help = "Upper bound").double().default(27.0)

    override fun run() {
        val app: NeverTellMeTheOdds = NeverTellMeTheOdds(input.readText(Charsets.UTF_8))

        val result_1: Int = app.solution1(minVal, maxVal)
        println("1. Solution: $result_1")

        val result_2: Int = app.solution2()
        println("2. Solution: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
