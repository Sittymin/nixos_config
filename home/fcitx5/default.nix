{ config
, pkgs
, rime_dicts
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
      source = "${rime_dicts}/cn_dicts";
    };
  };
}
