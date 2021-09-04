{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  # I like to define variables for derivations that have
  # a specific version and are subject to change over time.
  elixir = beam.packages.erlangR24.elixir_1_12;
in

mkShell {
  buildInputs = [
    elixir
    inotify-tools
    nodejs
    chromedriver
    google-chrome
  ];

  shellHook = ''
    export CHROME_BINARY=${google-chrome}/bin/google-chrome-stable
  '';
}