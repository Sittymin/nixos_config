{ ...
}: {
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    settings = {
      tab_bar_edge = "top";
      background_opacity = "0.5";
      # 新建窗口的布局
      enabled_layouts = "Tall";
      # 模糊需要在窗口管理器
      font_family = "Monaspace Neon Var Regular";
      bold_font = "Monaspace Neon Var ExtraBold";
      italic_font = "Monaspace Neon Var Medium Italic";
      bold_italic_font = "Monaspace Neon Var ExtraBold Italic";
      modify_font = "baseline -2";
      font_size = "12.0";
      disable_ligatures = "cursor";
    };
    # TODOu 启用连字
    extraConfig =
      "\n        font_features MonaspaceNeonVar-Regular +calt +ss07 +ss09 +liga\n        font_features MonaspaceNeonVar_800wght  +calt +ss07 +ss09 +liga\n        symbol_map U+4E00-U+9FFF LXGW Neo XiHei\n        symbol_map U+2B58,U+E000-U+F8FF,U+F0000-U+FFFFD Symbols Nerd Font\n      symbol_map U+2300-U+23FF,U+2714,U+26A0,U+2193,U+2191,U+2205,U+2211 Symbola\n";
  };
}
