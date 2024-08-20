{ rime-dicts
, rime-double-pinyin
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
    ".local/share/fcitx5/rime/opencc" = {
      source = "${rime-dicts}/opencc";
    };
    ".local/share/fcitx5/rime/double_pinyin_flypy.schema.yaml" = {
      source = "${rime-double-pinyin}/double_pinyin_flypy.schema.yaml";
    };
  };
}
