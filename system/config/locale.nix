{ pkgs
, ...
}: {
  # NOTE:设置系统语言为中文
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];
    inputMethod = {
      enable = true;
      type = "fcitx5";
      # 修复环境变量的警告
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        fcitx5-rime
        # 日语支持
        fcitx5-anthy
      ];
    };
  };

  # NOTE:设置时区
  time.timeZone = "Asia/Hong_Kong";
}
