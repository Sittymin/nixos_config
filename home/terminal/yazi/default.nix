{ inputs
, ...
}: {
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
  };
  home.file = {
    ".config/yazi/yazi.toml" = {
      source = ./yazi.toml;
    };
    ".config/yazi/theme.toml" = {
      source = "${inputs.catppuccin-yazi}/themes/mocha.toml";
    };
    ".config/yazi/Catppuccin-mocha.tmTheme" = {
      source = "${inputs.catppuccin-bat}/themes/Catppuccin Mocha.tmTheme";
    };
  };

}
