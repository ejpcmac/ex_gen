use Mix.Releases.Config,
  default_release: :<%= @app %>,
  default_environment: Mix.env()

# For a full list of config options for both releases and environments, visit
# https://hexdocs.pm/distillery/configuration.html

environment :dev do
  set cookie:
        :"<%= @cookie %>"
end

environment :prod do
  set cookie:
        :"<%= @cookie %>"
end

# Release for the Nerves system.
release :<%= @app %> do
  set version: current_version(:<%= @app %>)
  plugin Shoehorn
  plugin Nerves
end
