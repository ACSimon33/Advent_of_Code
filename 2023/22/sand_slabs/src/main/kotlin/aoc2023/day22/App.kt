package aoc2023.day22

// Import solution and CLI argument parser
import aoc2023.day22.sandSlabs.SandSlabs
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 22: Sand Slabs") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: SandSlabs = SandSlabs(input.readText(Charsets.UTF_8))

        val result_1: Int = app.amountOfDisintegratableBricks()
        println("Safely disintegratable bricks: $result_1")

        val result_2: Int = app.amountOfFallingBricks()
        println("Sum of falling bricks: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
