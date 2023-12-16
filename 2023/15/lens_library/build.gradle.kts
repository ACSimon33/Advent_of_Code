import kotlinx.benchmark.gradle.JvmBenchmarkTarget

plugins {
    id("org.jetbrains.kotlin.jvm")
    id("org.jetbrains.kotlinx.benchmark")
    id("com.ncorti.ktfmt.gradle")
    application
}

repositories {
    mavenCentral()
}

dependencies {
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
    testImplementation("org.junit.jupiter:junit-jupiter-engine:5.9.3")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
    implementation("com.github.ajalt.clikt:clikt:4.2.1")
}

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(17))
    }
}

application {
    // Define the main class for the application.
    mainClass.set("aoc2023.day15.AppKt")
}

tasks.named<Test>("test") {
    // Use JUnit Platform for unit tests.
    useJUnitPlatform()
}

sourceSets.create("benchmarks")

kotlin.sourceSets.getByName("benchmarks") {
    dependencies {
        implementation("org.jetbrains.kotlinx:kotlinx-benchmark-runtime:0.4.4")

        implementation(sourceSets.main.get().output)
        implementation(sourceSets.main.get().runtimeClasspath)
    }
}

benchmark {
    configurations {
        named("main") {
            // configure default configuration
        }
    }
    targets {
        register("benchmarks") {
            this as JvmBenchmarkTarget
            jmhVersion = "1.21"
        }
    }
}

ktfmt {
    kotlinLangStyle()
}
