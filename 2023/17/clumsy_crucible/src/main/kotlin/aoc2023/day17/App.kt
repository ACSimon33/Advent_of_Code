package aoc2023.day17

// Import solution and CLI argument parser
import aoc2023.day17.clumsyCrucible.ClumsyCrucible
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 17: Clumsy Crucible") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: ClumsyCrucible = ClumsyCrucible(input.readText(Charsets.UTF_8))

        val result_1: Int = app.leastHeatLoss(1, 3)
        println("Least heat loss with standard crucibles: $result_1")

        val result_2: Int = app.leastHeatLoss(4, 10)
        println("Least heat loss with ultra crucibles: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
