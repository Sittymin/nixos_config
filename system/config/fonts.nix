{ pkgs
, ...
}: {
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      # Icon fonts
      material-symbols
      # Nerd Fonts
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      # (nerdfonts.override { fonts = [ "Monaspace" ]; })
      # mono fonts
      # kitty用的是Var版本
      monaspace
      # 补全nom需要的字体
      symbola
      lxgw-neoxihei
      lxgw-wenkai
      noto-fonts-color-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "Monaspace Neon" "Noto Color Emoji" ];
        sansSerif = [ "LXGW Neo XiHei" "Noto Color Emoji" ];
        serif = [ "LXGW WenKai" "Noto Color Emoji" ];
      };
    };
    # 触发问题比解决问题多
    # https://github.com/fufexan/dotfiles/blob/0cf7097bb093f3f60a165981a1996d9cf6e96f9f/system/programs/fonts.nix#L21
    enableDefaultPackages = false;
  };
}
