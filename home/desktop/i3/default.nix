{
  ...
}:
{
  xdg.configFile = {
    # 无法直接使用软链接文件，可能stylix先行一步了
    "i3/config" = {
      source = ./config;
    };
  };
  home.file.".xinitrc".source = ./.xinitrc;
  xresources.properties = {
    # DPI 设置（使用主显示器的 DPI）
    # 96 为默认的 DPI
    # "Xft.dpi" = 162;
    "Xft.dpi" = 96;

    # ! 字体渲染设置
    "Xft.antialias" = 1;
    "Xft.hinting" = 1;
    "Xft.rgba" = "rgb";
    "Xft.hintstyle" = "hintslight";
    "Xft.lcdfilter" = "lcddefault";
  };
}
