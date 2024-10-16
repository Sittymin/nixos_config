{ inputs
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
      # 强制覆盖
      force = true;
    };
    ".local/share/fcitx5/rime/cn_dicts" = {
      source = "${inputs.rime-dicts}/cn_dicts";
    };
    ".local/share/fcitx5/rime/opencc" = {
      source = "${inputs.rime-dicts}/opencc";
    };
    ".local/share/fcitx5/rime/double_pinyin_flypy.schema.yaml" = {
      source = "${inputs.rime-double-pinyin}/double_pinyin_flypy.schema.yaml";
    };
  };
}
