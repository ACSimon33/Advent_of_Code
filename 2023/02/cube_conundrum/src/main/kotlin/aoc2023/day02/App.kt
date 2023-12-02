package aoc2023.day02

// Import solution and CLI argument parser
import aoc2023.day02.cubeConundrum.CubeConundrum
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 02: Cube Conundrum") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: CubeConundrum = CubeConundrum(input.readText(Charsets.UTF_8))

        val result_1: Int = app.sumOfPossibleGameIds()
        println("Sum of possible game ids: $result_1")

        val result_2: Int = app.sumOfGamePowers()
        println("Sum of game powers: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
