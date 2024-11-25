{
  inputs,
  ...
}:
{
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
  };
  xdg.configFile = {
    "yazi/yazi.toml" = {
      source = ./yazi.toml;
    };
    "yazi/theme.toml" = {
      source = "${inputs.catppuccin-yazi}/themes/mocha.toml";
    };
    "yazi/Catppuccin-mocha.tmTheme" = {
      source = "${inputs.catppuccin-bat}/themes/Catppuccin Mocha.tmTheme";
    };
  };

}
