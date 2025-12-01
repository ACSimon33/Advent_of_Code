defmodule ElixirTemplate.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_template,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: ElixirTemplate.CLI, path: "_build/bin/elixir_template"],
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
      {:benchee_html, "~> 1.0"}
    ]
  end

  defp aliases do
    [
      bench: "run benchmarks/puzzle_benchmarks.exs",
      solve: ["escript.build", &run_escript/1]
    ]
  end

  defp run_escript(_) do
    Mix.shell().cmd("escript _build/bin/elixir_template -f input/puzzle_input.txt")
  end
end
