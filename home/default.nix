{
  pkgs,
  inputs,
  pkgs-e0464e4,
  ...
}:

{
  imports = [
    ./terminal
    ./desktop
    ./other
  ];

  # 注意修改这里的用户名与用户目录
  home.username = "Sittymin";
  home.homeDirectory = "/home/Sittymin";
  home.stateVersion = "24.11";

  # # 直接将当前文件夹的配置文件，链接到 Home 目录下的指定位置
  # home.file = {
  #   ".config/user-dirs.dirs".source = ./user-dirs.dirs;
  # };

  # 似乎是设置默认下载、音乐、文档等目录的配置文件
  xdg.configFile."user-dirs.dirs".source = ./user-dirs.dirs;

  # 递归将某个文件夹中的文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # 递归整个文件夹
  #   executable = true;  # 将其中所有文件添加「执行」权限
  # };

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  home.packages =
    with pkgs;
    [
      # Docker 的一个插件
      docker-compose
      # Scheme 一个实现
      racket
      # Guix 包管理器
      guix
      # 语言
      guile
      # 数据库
      postgresql
      libreoffice
      # 测试显示器的VRR
      # vrrtest
      fastfetch
      yt-dlp
      # hyprpicker
      mpvpaper
      # Log
      lnav
      libjxl
      libavif
      # 一个回收站工具
      trash-cli
      # 基于libvips的图片浏览器
      # vipsdisp
      # 基于Qt的图片浏览器
      # (qview.override {
      #   x11Support = false;
      # })
      inputs.nixpkgs-wayland.packages.${pkgs.system}.imv
      (ffmpeg-full.override {
        withVpl = true;
        withMfx = false;
      })
      vscode
      # Doc view
      evince
      # EPUB and other
      foliate
      # GUI文件管理器
      xfce.thunar
      # 缩略图
      xfce.tumbler
      # 配置软件（也会配置默认启动软件）
      # 配置在 ~/.config/xfce4/helpers.rc
      xfce.xfce4-settings
      # 归档文件查看器
      # file-roller
      scrcpy

      python311
      # JDK
      graalvm-ce
      # nodejs
      bun
      nodePackages_latest.nodejs
      rustup

      # 与Nix相关的工具，提供更详细的日志输出。
      # nh 内置
      # nix-output-monitor

      lsof # 列出打开文件的工具

      # 用于调节音频设备的软件
      # helvum

      #wine
      wineWowPackages.waylandFull
      # 种子文件客户端
      qbittorrent
      # cli 的版本
      qbittorrent-nox
      # 矢量图形编辑器
      inkscape
      # 绘画应用程序
      # krita
      # GTK 图像处理程序
      # pinta
      # blender
      # epiphany
      font-manager
      # gnome
      dconf-editor
      d-spy
      # (heroic.override {
      #   extraPkgs = pkgs: [
      #     gamemode
      #   ];
      # })

      # 同步文件
      syncthing

      (android-studio.override {
        forceWayland = true;
      })
      (jetbrains.plugins.addPlugins jetbrains.idea-ultimate [
        "17718"
      ])
      (godot_4.override {
        withWayland = true;
        # Wayland only 需要 https://github.com/godotengine/godot/pull/97771
        # withX11 = false;
      })
    ]
    ++ (with pkgs-e0464e4; [
      localsend
    ]);

  xdg.mimeApps = {
    enable = true;
    ## 默认应用 参考: https://specifications.freedesktop.org/mime-apps-spec/mime-apps-spec-latest.html
    # desktop 文件在 $env.XDG_DATA_DIRS 环境变量的各个目录中
    # 系统级
    # /etc/profiles/per-user/Sittymin/share
    # /run/current-system/sw/share
    # 用户级
    # ~/.local/state/nix/profiles/home-manager/home-path/share/applications
    # mime 可以通过 `file --mime-type 文件名` 查看
    # Example:
    # "application/pdf" = "firefox.desktop";
    # "image/png" = [
    #   "sxiv.desktop"
    #   "gimp.desktop"
    # ];
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      # 终端
      "x-scheme-handler/terminal" = "kitty.desktop";
      # 文件夹打开方式
      "inode/directory" = "thunar.desktop";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    # 需要修补，否则回退图标直接就是 hicolor 而不会中间经过指定图标
    package = pkgs.google-cursor;
    name = "GoogleDot-Black";
    size = 24; # 1080P下16，2K下24
  };
  # https://nix-community.github.io/home-manager/options.xhtml
  gtk = {
    enable = true;
    # 实际上可能只对完整桌面环境有效
    # theme = {
    #   name = "Catppuccin-Mocha-Pink";
    #   package = pkgs.catppuccin-gtk.override {
    #     accents = [ "pink" ];
    #     tweaks = [
    #       "rimless"
    #       "black"
    #     ];
    #     variant = "mocha";
    #   };
    # };
    gtk2.extraConfig = ''
      gtk-im-module="fcitx"
      gtk-icon-theme-name="Papirus-Dark"
    '';
    gtk3.extraConfig = {
      # 图标主题
      gtk-icon-theme-name = "Papirus-Dark";

      # GTK3偏好暗色主题
      gtk-application-prefer-dark-theme = true;
      gtk-im-module = "fcitx";
    };
    gtk4.extraConfig = {
      # 图标主题
      gtk-icon-theme-name = "Papirus-Dark";
      # GTK4偏好暗色主题
      gtk-application-prefer-dark-theme = true;
      gtk-im-module = "fcitx";
    };
    # 好像没啥用？（上游似乎是一个远古代码）
    # iconTheme = {
    #   name = "Papirus-Dark";
    #   package = pkgs.papirus-icon-theme;
    # };
  };
  # 将图标软链接到 ~/.local/share/icons
  # 正确读取图标了（这个是用户的，全局要在 usr/share，只要全局配置安装 icon 就会链接到那）
  xdg.dataFile = {
    # 回退主题部分（即 index.theme 的 Inherits 部分）
    # 这个使用 Papirus-Dark 虽然会让所有软件使用 Papirus-Dark 图标但是会缺失图标
    # 所以用override 将原始 hicolor 文件夹改名为 hicolor-backup
    # Papirus 主题的 hicolor 回退修改为 hicolor-backup
    "icons/hicolor" = {
      source = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
    };
    "icons/hicolor-backup" = {
      source = "${pkgs.papirus-icon-theme}/share/icons/hicolor";
    };
    # 中间回退部分的主题
    "icons/Papirus" = {
      source = "${pkgs.papirus-icon-theme}/share/icons/Papirus";
    };
    "icons/breeze-dark" = {
      source = "${pkgs.papirus-icon-theme}/share/icons/breeze-dark";
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        icon-theme = "Papirus-Dark";
        # 设置GTK颜色偏好为暗色
        color-scheme = "prefer-dark";
      };
      # https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.Settings.html
      "org/freedesktop/appearance".color-scheme = 1;
      # KVM
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemuu///system" ];
      };
      # KVM 默认虚拟机使用缩放
      "org/virt-manager/virt-manager/console".scaling = 2;
    };
  };

  # 设置字体 DPI（适用于 2K 显示器）
  # xresources.properties = {
  #   "Xft.dpi" = 120;
  # };

  programs = {
    git = {
      enable = true;
      userName = "Sittymin";
      userEmail = "mail@sittymin.top";
      signing = {
        key = "747FDF0404DC5B77";
        signByDefault = true;
      };
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        # wayland 录屏
        wlrobs
        # pipewire 录音
        obs-pipewire-audio-capture
      ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
