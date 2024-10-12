{ ...
}: {
  home = {
    file = {
      # 无法直接使用软链接文件，可能stylix先行一步了
      ".config/niri" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
