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
    file."firefox-gnome-theme" = {
      target = ".mozilla/firefox/default/chrome/firefox-gnome-theme";
      #     需要flake导入
      source = inputs.firefox-gnome-theme;
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
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

        #       设置firefox语言
        "font.language.group" = "zh-CN";
        #       设置网站首选语言
        "intl.accept_languages" = "zh-cn,zh,zh-tw";
        #       设置下载默认文件夹
        "browser.download.dir" = "/home/Sittymin/Downloads";
      };
      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
      '';
      userContent = ''
        @import "firefox-gnome-theme/userContent.css";
      '';
      extensions =
        [
        ];
    };
  };
}
