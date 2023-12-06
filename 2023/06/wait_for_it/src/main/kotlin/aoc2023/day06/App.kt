package aoc2023.day06

// Import solution and CLI argument parser
import aoc2023.day06.waitForIt.WaitForIt
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 06: Wait For It") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: WaitForIt = WaitForIt(input.readText(Charsets.UTF_8))

        val result_1: Long = app.amoutOfWinsMultipleRaces()
        println("Amount of wins for multiple short races: $result_1")

        val result_2: Long = app.amoutOfWinsSingleRace()
        println("Amount of wins for single long race: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
