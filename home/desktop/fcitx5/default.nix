{
  inputs,
  ...
}:
{
  # 这里用于链接文件 fcitx5 设置在全局配置中
  xdg = {
    # ~/.local/share
    dataFile = {
      "fcitx5/rime" = {
        source = ./rime;
        recursive = true;
      };

      "fcitx5/themes" = {
        # 不知道为啥不可以使用 SVG 作为背景
        # source = "${inputs.fcitx5-mellow-themes}";
        source = ./themes;
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
