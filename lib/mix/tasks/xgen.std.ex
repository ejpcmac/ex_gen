defmodule Mix.Tasks.Xgen.Std do
  use Mix.Task

  @shortdoc "Generates a standard Elixir project"

  @moduledoc """
  Generates a standard Elixir project.
  """

  @switches [
    app: :string,
    module: :string,
    sup: :boolean,
    contrib: :boolean,
    package: :boolean,
    license: :string,
    todo: :boolean,
    config: :string
  ]

  @impl true
  def run(args) do
    {opts, argv} = OptionParser.parse!(args, strict: @switches)

    case argv do
      [] ->
        Mix.raise("Expected PATH to be given. Please use `mix xgen.std PATH`.")

      [path | _] ->
        nil
        app = opts[:app] || path |> Path.expand() |> Path.basename()
        mod = opts[:module] || Macro.camelize(app)

        unless path == "." do
          check_directory_existence!(path)
          File.mkdir_p!(path)
        end

        compiled? =
          File.cd!(path, fn ->
            ExGen.generate(:std, app, mod, opts)
            ExGen.build(:std)
          end)

        Mix.shell().info("""

        Your project has been successfully created.
        """)

        unless compiled? do
          Mix.shell().info("""
          You can now fetch its dependencies and compile it:

              cd #{path}
              mix deps.get
              mix compile

          You can also run tests:

              mix test
          """)
        end

        Mix.shell().info("""
        After your first commit, you can setup gitflow:

            ./.gitsetup
        """)
    end
  end

  @spec check_directory_existence!(String.t()) :: nil | no_return()
  defp check_directory_existence!(path) do
    msg =
      "The directory #{inspect(path)} already exists. Are you sure you want " <>
        "to continue?"

    if File.dir?(path) and not Mix.shell().yes?(msg) do
      Mix.raise("Please select another directory for installation")
    end
  end
end
