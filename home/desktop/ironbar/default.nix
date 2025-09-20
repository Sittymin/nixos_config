{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.ironbar.homeManagerModules.default
  ];

  xdg.configFile."ironbar" = {
    source = ./config;
    recursive = true;
  };
  # home = {
  # file = {
  #   ".config/ironbar" = {
  #     source = ./config;
  #     recursive = true;
  #   };
  # };
  #   packages = [
  #     pkgs.ironbar
  #   ];
  # };
  programs.ironbar = {
    enable = true;
    # config = /home/Sittymin/.config/ironbar/config.toml;
  };
}
