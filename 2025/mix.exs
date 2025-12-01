defmodule AoC2025.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:benchee, "~> 1.0"},
      {:benchee_html, "~> 1.0"}
    ]
  end

  defp aliases do
    [
      bench: "run benchmarks/run_all.exs"
    ]
  end
end
