{ config, pkgs, ... }:

{
  # 注意修改这里的用户名与用户目录
  home.username = "Sittymin";
  home.homeDirectory = "/home/Sittymin";

  # 直接将当前文件夹的配置文件，链接到 Home 目录下的指定位置
  home.file = {
    ".config/hypr/hyprland.conf".source = ./hyprland/hyprland.conf;
    "sing-box/config.json".source = ./singbox/config.json;
    ".config/waybar/config.json".source = ./waybar/config.json;
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




  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };


  # 设置鼠标指针大小以及字体 DPI（适用于 2K 显示器）
#  xresources.properties = {
#
#    "Xcursor.size" = 24;
#    "Xft.dpi" = 120;
#  };

  # git 相关配置
  programs = {
    git = {
      enable = true;
      userName = "Sittymin";
      userEmail = "wu2890108976@gmail.com";
    };
    #anyrun = {
    #  enable = true;
    #};
  };

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs;[
    firefox
    neofetch # 显示系统信息的工具，如操作系统、内核版本、CPU、内存等。
    yazi # terminal file manager
    neovim

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # 替代grep
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    eza # 现代化的ls命令替代品，用于列出文件和目录。
    fzf # 命令行模糊查找工具。

    sing-box

    # 与Nix相关的工具，提供更详细的日志输出。
    nix-output-monitor

    glow # markdown previewer in terminal

    btop  # 系统和网络监控工具
    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # 桌面环境相关
    waybar # 一个漂亮的状态栏
    
  ];


  programs = {
    nushell = {
      enable = true;
    };
    # 一个自动补全工具
    carapace.enable = true;
    carapace.enableNushellIntegration = true;
    # 启用 starship，这是一个漂亮的 shell 提示符
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };

  # alacritty - 一个跨平台终端，带 GPU 加速功能
  programs.alacritty = {
    enable = true;
    # 自定义配置
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };



  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
