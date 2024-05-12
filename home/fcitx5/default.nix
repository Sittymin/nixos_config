{ rime-dicts
, ...
}: {
  home.file = {
    ".local/share/fcitx5" = {
      source = ./.local/fcitx5;
      recursive = true;
    };
    ".config/fcitx5" = {
      source = ./.config/fcitx5;
      recursive = true;
    };
    ".local/share/fcitx5/rime/cn_dicts" = {
      source = "${rime-dicts}/cn_dicts";
    };
  };
}
