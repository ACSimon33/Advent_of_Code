defmodule SecretEntrance.MixProject do
  use Mix.Project

  def project do
    [
      app: :day01_secret_entrance,
      version: "0.1.0",
      build_path: "../../_build",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: SecretEntrance.CLI, path: "../../_build/bin/secret_entrance"],
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 1.0"},
      {:benchee_html, "~> 1.0"},
      {:junit_formatter, "~> 3.4", only: [:test]}
    ]
  end

  defp aliases do
    [
      bench: "run #{__DIR__}/benchmarks/puzzle_benchmarks.exs",
      exec: [&run_escript_with_args/1],
      solve: ["escript.build", &run_escript/1]
    ]
  end

  defp run_escript(_) do
    Mix.shell().cmd(
      "escript ../../_build/bin/secret_entrance -f #{__DIR__}/input/puzzle_input.txt"
    )
  end

  defp run_escript_with_args(_) do
    args = System.argv() |> Enum.join(" ")
    Mix.shell().cmd("escript ../../_build/bin/secret_entrance #{args}")
  end
end
