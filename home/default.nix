{ nixpkgs-wayland
, pkgs
, ...
}:

{
  imports = [
    ./fcitx5
    ./ironbar
    ./firefox
    ./anyrun
    ./minecraft
    ./shell
    ./fontconfig
    ./hypr
    ./niri
    ./helix
    ./mpv
    ./cheat
  ];

  # 注意修改这里的用户名与用户目录
  home.username = "Sittymin";
  home.homeDirectory = "/home/Sittymin";
  home.stateVersion = "24.05";

  # 直接将当前文件夹的配置文件，链接到 Home 目录下的指定位置
  home.file = {
    ".config/mako/config".source = ./mako/config;
    ".config/yazi" = {
      source = ./yazi;
      recursive = true;
      executable = true;
    };
  };


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

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs; [
    libreoffice
    # 测试显示器的VRR
    vrrtest
    fastfetch
    lux
    cpu-x
    # hyprpicker
    mpvpaper
    # Log
    tailspin
    # BLAKE3 加密哈希函数
    b3sum
    libjxl
    libavif
    # 一个回收站工具
    trashy
    # 基于libvips的图片浏览器
    # vipsdisp
    # Qt图片加载库（JXL）
    libsForQt5.kimageformats
    # GTK_image_lib
    gdk-pixbuf
    # 基于Qt的图片浏览器
    # (qview.override {
    #   x11Support = false;
    # })
    nixpkgs-wayland.packages.${pkgs.system}.imv
    (ffmpeg-full.override {
      withVpl = true;
      withMfx = false;
    })
    vscode
    # 还是等到支持Wayland吧
    # jetbrains.idea-ultimate
    # Doc view
    evince
    # EPUB and other
    foliate
    # vim复制到系统剪贴
    wl-clipboard
    # archives
    zip # 压缩为zip
    unzip # 解压zip
    xz # xz
    p7zip # 7z
    zstd # zstd
    # unrar # rar
    rar
    zpaqfranz

    # GUI文件管理器
    gnome.nautilus
    # 归档文件查看器
    gnome.file-roller
    # adb_and_other
    android-tools
    scrcpy

    python39
    # JDK
    graalvm-ce
    # nodejs
    bun
    nodejs_22
    # nodePackages.vls
    rustup

    # 与Nix相关的工具，提供更详细的日志输出。
    # nh 内置
    # nix-output-monitor

    btop # 系统和网络监控工具

    # 缺少memory, power, fan and temperature
    # 参见https://github.com/Syllo/nvtop/issues/197
    nvtopPackages.intel
    intel-gpu-tools # 可以用intel_gpu_top显示Arc显卡占用情况

    lsof # 列出打开文件的工具

    # 用于调节音频设备的软件
    # helvum

    # 通知程序
    mako

    #wine
    wineWowPackages.waylandFull
    qq
    telegram-desktop
    # 命令行备忘录
    cheat
    # 种子文件客户端
    transmission_4
    transmission-remote-gtk
    # 矢量图形编辑器
    inkscape
    # 绘画应用程序
    # krita
    # GTK 图像处理程序
    pinta
    blender
    godot_4
    epiphany
    font-manager
    # gnome
    gnome.dconf-editor
    d-spy
    # Matrix群组消息应用程序
    # fractal
    # Markdown编辑器
    apostrophe
    # GTK编写的远程桌面客户端
    # remmina
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.google-cursor;
    name = "GoogleDot-Black";
    size = 24; # 1080P下16，2K下24
  };
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Pink";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        tweaks = [ "rimless" "black" ];
        variant = "mocha";
      };
    };
    # GTK3/4偏好暗色主题
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    gtk4.extraConfig = { gtk-application-prefer-dark-theme = true; };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };
  # 设置GTK颜色偏好为暗色
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
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
      userEmail = "wu2890108976@gmail.com";
    };
    # 一个自动补全工具
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    kitty = {
      enable = true;
      theme = "Catppuccin-Mocha";
      settings = {
        tab_bar_edge = "top";
        background_opacity = "0.5";
        # 新建窗口的布局
        enabled_layouts = "Tall";
        # 模糊需要在窗口管理器
        font_family = "Monaspace Neon Var Regular";
        bold_font = "Monaspace Neon Var ExtraBold";
        italic_font = "Monaspace Neon Var Medium Italic";
        bold_italic_font = "Monaspace Neon Var ExtraBold Italic";
        modify_font = "baseline -2";
        font_size = "12.0";
        disable_ligatures = "cursor";
      };
      # TODOu 启用连字
      extraConfig =
        "\n        font_features MonaspaceNeonVar-Regular +calt +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07 +ss08 +liga\n        font_features MonaspaceNeonVar_800wght +calt +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07 +ss08 +liga\n        symbol_map U+4E00-U+9FFF LXGW Neo XiHei\n        symbol_map U+2B58,U+E000-U+F8FF,U+F0000-U+FFFFD Symbols Nerd Font\n      symbol_map U+2300-U+23FF,U+2714,U+26A0,U+2193,U+2191,U+2205,U+2211 Symbola\n";
    };
    # https://github.com/zellij-org/zellij/issues/2814
    zellij = {
      enable = true;
    };
    yazi = {
      enable = true;
      enableNushellIntegration = true;
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
