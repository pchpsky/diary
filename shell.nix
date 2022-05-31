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
    ngrok
    jq
    killall
  ];

  shellHook = ''
    source secrets.sh
    export CHROME_BINARY=${google-chrome}/bin/google-chrome-stable
    alias server="mix phx.server"
    alias ngrok_start="ngrok http 4000 --log=stdout > /dev/null &"
    alias ngrok_stop="killall -q ngrok"
    alias ngrok_url='curl http://localhost:4040/api/tunnels | jq ".tunnels[0].public_url"'
    alias set_ngrok_host='export PHX_HOST=$ngrok_url'
  '';
}
