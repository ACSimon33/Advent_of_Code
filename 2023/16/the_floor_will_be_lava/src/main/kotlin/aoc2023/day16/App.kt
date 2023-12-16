package aoc2023.day16

// Import solution and CLI argument parser
import aoc2023.day16.theFloorWillBeLava.TheFloorWillBeLava
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 16: The Floor Will Be Lava") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: TheFloorWillBeLava = TheFloorWillBeLava(input.readText(Charsets.UTF_8))

        val result_1: Int = app.amountOfEnergizedTiles()
        println("Amount of energized tiles: $result_1")

        val result_2: Int = app.maximumAmountOfEnergizedTiles()
        println("Maximum amount of energized tiles: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
