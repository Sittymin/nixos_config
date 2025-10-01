{
  pkgs,
  inputs,
  ...
}:
{
  home = {
    #   配置BROWSER环境变量为firefox
    sessionVariables.BROWSER = "firefox";

    #   使用firefox-gnome-theme主题
    # file."firefox-gnome-theme" = {
    #   target = ".mozilla/firefox/default/chrome/firefox-gnome-theme";
    #   #     需要flake导入
    #   source = inputs.firefox-gnome-theme;
    # };
    file."firefox-gnome-theme-nightly" = {
      target = ".mozilla/firefox/default/chrome/firefox-gnome-theme-nightly";
      source = inputs.firefox-gnome-theme-nightly;
    };
  };

  programs.firefox = {
    enable = true;
    # 如果要中文版就需要下载另外的软件包，但是提供的都是硬编码的英文
    package = inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin;
    # package = pkgs.firefox-wayland;
    # https://github.com/nix-community/home-manager/blob/83ecd50915a09dca928971139d3a102377a8d242/modules/programs/firefox/mkFirefoxModule.nix#L269
    languagePacks = [ "zh-CN" ];
    # 组织设置 无法浏览器更改
    policies = {
      DefaultDownloadDirectory = "\${home}/Downloads";
      # 启用或禁用网页翻译
      TranslateEnabled = false;
      # 移除 Firefox 界面中的 Pocket 功能。这不会从新标签页中移除它。
      DisablePocket = true;
      # 禁用默认书签的创建
      NoDefaultBookmarks = true;
      # 设置应用程序的首选语言环境列表
      RequestedLocales = [ "zh-CN" ];
    };
    profiles.default = {
      name = "Default";
      settings = {
        "browser.tabs.loadInBackground" = true;
        #       使用主题需要
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        #       主题的自定义设置
        #       只有一个标签页打开时隐藏标签栏
        "gnomeTheme.hideSingleTab" = true;
        #       将书签工具栏移动到选项卡下方
        "gnomeTheme.bookmarksToolbarUnderTabs" = true;
        #       普通宽度的标签
        "gnomeTheme.normalWidthTabs" = false;
        #       将选项卡放置在窗口顶部
        "gnomeTheme.tabsAsHeaderbar" = false;
      };
      # Stable 版本
      # userChrome = ''
      #   @import "firefox-gnome-theme/userChrome.css";
      # '';
      # userContent = ''
      #   @import "firefox-gnome-theme/userContent.css";
      # '';
      # Nightly 版本
      userChrome = ''
        @import "firefox-gnome-theme-nightly/userChrome.css";
      '';
      userContent = ''
        @import "firefox-gnome-theme-nightly/userContent.css";
      '';
    };
  };
}
