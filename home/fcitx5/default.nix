{
  config,
  pkgs,
  ...
} : {
  home.file = {
    ".local/share" = {
      source = ./.local/share;
      recursive = true;
    };
    ".config/fcitx5" = {
      source = ./.config/fcitx5;
      recursive = true;
    };
  };
}
