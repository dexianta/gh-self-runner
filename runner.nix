{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.gnumake
    pkgs.go
    pkgs.python38
    pkgs.docker
  ];

  shellHook = ''
    echo "welcome to the github action runner shell"
  '';
}
