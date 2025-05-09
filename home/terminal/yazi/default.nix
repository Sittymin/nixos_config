{
  inputs,
  pkgs,
  ...
}:
{
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
  };
  home.packages = [
    # 拖动文件(好像拖过去没反应)
    pkgs.dragon-drop
    # 作为默认文件管理器(似乎没有起作用)
    pkgs.xdg-desktop-portal-termfilechooser
  ];
  xdg.configFile = {
    "yazi/yazi.toml" = {
      source = ./yazi.toml;
    };
    "yazi/keymap.toml" = {
      source = ./keymap.toml;
    };
    "yazi/theme.toml" = {
      source = "${inputs.catppuccin-yazi}/themes/mocha/catppuccin-mocha-blue.toml";
    };
    "yazi/Catppuccin-mocha.tmTheme" = {
      source = "${inputs.catppuccin-bat}/themes/Catppuccin Mocha.tmTheme";
    };
    "yazi/init.lua" = {
      source = ./init.lua;
    };
    # 不起作用... 不明白
    "xdg-desktop-portal-termfilechooser/config" = {
      source = "${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/config";
    };
    "xdg-desktop-portal-termfilechooser/yazi-wrapper.sh" = {
      source = "${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh";
    };

  };

}
