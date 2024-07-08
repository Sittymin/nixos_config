{ pkgs, ... }: {
  imports = [
    ./nushell
    ./starship
    ./zellij
    ./kitty
  ];
}
