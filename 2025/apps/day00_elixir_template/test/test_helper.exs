ExUnit.configure(
  formatters: [
    # {JUnitFormatter, report_file: "elixir_template_test.xml", report_dir: "_build/test"},
    ExUnit.CLIFormatter
  ]
)

ExUnit.start()
