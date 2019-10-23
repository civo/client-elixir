defmodule Earmark.Mixfile do
  use Mix.Project

  @version "1.4.1"
  @url "https://github.com/pragdave/earmark"


  @deps [
    # {:credo, "~> 0.10", only: [:dev, :test]},
    # {:dialyxir, "~> 0.5", only: [:dev, :test]}
    {:floki, "~> 0.21", only: [:dev, :test]},
  ]

  @description """
  Earmark is a pure-Elixir Markdown converter.

  It is intended to be used as a library (just call Earmark.as_html),
  but can also be used as a command-line tool (run mix escript.build
  first).

  Output generation is pluggable.
  """

  ############################################################

  def project do
    [
      app: :earmark,
      version: @version,
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      escript: escript_config(),
      deps: @deps,
      description: @description,
      package: package(),
      aliases: [docs: &build_docs/1, readme: &readme/1]
    ]
  end

  def application do
    [
      applications: []
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "src/*.xrl",
        "src/*.yrl",
        "tasks",
        "mix.exs",
        "README.md"
      ],
      maintainers: [
        "Robert Dober <robert.dober@gmail.com>",
        "Dave Thomas <dave@pragdave.me>"
      ],
      licenses: [
        "Apache 2 (see the file LICENSE for details)"
      ],
      links: %{
        "GitHub" => "https://github.com/pragdave/earmark"
      }
    ]
  end

  defp escript_config do
    [main_module: Earmark.CLI]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support", "dev"]
  defp elixirc_paths(:dev), do: ["lib", "dev"]
  defp elixirc_paths(_), do: ["lib"]

  @prerequisites """
  run `mix escript.install hex ex_doc` and adjust `PATH` accordingly
  """
  defp build_docs(_) do
    Mix.Task.run("compile")
    ex_doc = Path.join(Mix.Local.path_for(:escript), "ex_doc")
    Mix.shell.info("Using escript: #{ex_doc} to build the docs")

    unless File.exists?(ex_doc) do
      raise "cannot build docs because escript for ex_doc is not installed, make sure to \n#{@prerequisites}"
    end

    args = ["Earmark", @version, Mix.Project.compile_path()]
    opts = ~w[--main Earmark --source-ref v#{@version} --source-url #{@url}]

    Mix.shell.info("Running: #{ex_doc} #{inspect(args ++ opts)}")
    System.cmd(ex_doc, args ++ opts)
    Mix.shell.info("Docs built successfully")
  end

  defp readme(args) do
    Code.load_file("tasks/readme.exs")
    Mix.Tasks.Readme.run(args)
  end
end

# SPDX-License-Identifier: Apache-2.0
