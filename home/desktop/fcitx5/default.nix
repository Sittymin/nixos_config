{ inputs
, ...
}: {
  xdg = {
    # ~/.local/share
    dataFile = {
      "fcitx5" = {
        source = ./share;
        recursive = true;
      };
      "fcitx5/rime/cn_dicts" = {
        source = "${inputs.rime-dicts}/cn_dicts";
      };
      "fcitx5/rime/opencc" = {
        source = "${inputs.rime-dicts}/opencc";
      };
      "fcitx5/rime/double_pinyin_flypy.schema.yaml" = {
        source = "${inputs.rime-double-pinyin}/double_pinyin_flypy.schema.yaml";
      };
    };
  };
}
