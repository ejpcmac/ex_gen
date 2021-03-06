defmodule XGen.Generators.Elixir.Escript do
  @moduledoc """
  A generator for Elixir escripts.
  """

  use XGen.Generator

  import Marcus
  import XGen.Generator.StandardCallbacks
  import XGen.Generators.Elixir.Helpers

  alias XGen.Options.Base
  alias XGen.Options.Elixir.Base, as: ElixirBase

  type :escript

  name "Elixir escript"

  options [
    ElixirBase.Application,
    ElixirBase.Module,
    Base.CI,
    Base.Contributing,
    Base.License,
    Base.Git
  ]

  overrides %{
    initial_version: "0.0.1",
    module_path: Macro.underscore(@module)
  }

  collection do
    [
      "_base_/README.md.eex",
      "_base_/CHANGELOG.md.eex",
      "_elixir_/_base_/shell.nix.eex",
      "_base_/.envrc",
      "_base_/.editorconfig",
      "_elixir_/_escript_/.formatter.exs.eex",
      "_elixir_/_base_/.credo.exs",
      "_elixir_/_base_/.dialyzer_ignore",
      "_elixir_/_base_/.gitignore.eex",
      "_elixir_/_escript_/mix.exs.eex",
      "_elixir_/_base_/config/config.exs",
      "_elixir_/_escript_/lib/@module_path@.ex.eex",
      "_elixir_/_base_/test/support/",
      "_elixir_/_base_/test/test_helper.exs"
    ]
  end

  collection @ci? and @ci_service == :travis,
    do: ["_elixir_/_base_/.travis.yml"]

  collection @contributing?, do: ["_elixir_/_base_/CONTRIBUTING.md.eex"]
  collection @license?, do: ["_base_/LICENSE+#{@license}.eex"]
  collection @git?, do: ["_base_/.gitsetup"]

  postgen :init_git
  postgen :fetch_deps
  postgen :run_formatter
  postgen :project_created
  postgen :build_instructions
  postgen :gitsetup_instructions

  ##
  ## Post-generation callbacks
  ##

  @spec build_instructions(map()) :: map()
  defp build_instructions(opts) do
    info("""
    You can now build and execute the escript:

        cd #{opts.path}
        direnv allow
        mix escript.build
        ./#{opts.app}
    """)

    opts
  end
end
