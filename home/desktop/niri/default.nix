{
  ...
}:
{
  xdg.configFile = {
    # 无法直接使用软链接文件，可能stylix先行一步了
    "niri" = {
      source = ./config;
      recursive = true;
    };
  };
}
