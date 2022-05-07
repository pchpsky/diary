{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  elixir = beam.packages.erlangR24.elixir_1_13;
in

mkShell {
  buildInputs = [
    elixir
    inotify-tools
    nodejs
    nodePackages.npm
    chromedriver
    google-chrome
    flyctl
    wireguard-tools
    openresolv
  ];

  shellHook = ''
    export CHROME_BINARY=${google-chrome}/bin/google-chrome-stable
    alias server="mix phx.server"
  '';
}
