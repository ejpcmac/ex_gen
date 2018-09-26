{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  elixir = beam.packages.erlangR21.elixir_1_7;
  erlang = erlangR21;
  gitflow = gitAndTools.gitflow;
in

mkShell {
  buildInputs = [ elixir erlang git gitflow ];
}
