defmodule XGen.Wizards.ProjectGenerator do
  @moduledoc """
  A wizard to generate projects.
  """

  use XGen.Wizard

  alias XGen.Wizards.Std

  @project_types [
    std: "Standard Elixir project",
    nerves: "Nerves project"
  ]

  @impl true
  @spec run :: :ok
  @spec run(keyword()) :: :ok
  def run(opts \\ []) do
    config_file = opts[:config] || user_home() |> Path.join(".xgen.exs")

    case choose("Which kind of project do you want to start?", @project_types) do
      :std ->
        Std.run(config: config_file)

      :nerves ->
        info([:blue, "\nThe wizard for Nerves projects is not available yet.\n"])
    end
  end
end
