package aoc2023.day09

// Import solution and CLI argument parser
import aoc2023.day09.mirageMaintenance.MirageMaintenance
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 09: Mirage Maintenance") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: MirageMaintenance = MirageMaintenance(input.readText(Charsets.UTF_8))

        val result_1: Long = app.sumOfNextValues()
        println("Sum of predicted next values: $result_1")

        val result_2: Long = app.sumOfPreviousValues()
        println("Sum of predicted previous values: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
