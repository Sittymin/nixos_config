{ config, pkgs, ... }:

{
  # 注意修改这里的用户名与用户目录
  home.username = "Sittymin";
  home.homeDirectory = "/home/Sittymin";

  # 直接将当前文件夹的配置文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

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

  # 设置鼠标指针大小以及字体 DPI（适用于 2K 显示器）
  xresources.properties = {
    "Xcursor.size" = 24;
    "Xft.dpi" = 120;
  };

  # git 相关配置
  programs.git = {
    enable = true;
    userName = "Sittymin";
    userEmail = "wu2890108976@gmail.com";
  };

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs;[
    # 如下是我常用的一些命令行工具，你可以根据自己的需要进行增删
    neofetch # 显示系统信息的工具，如操作系统、内核版本、CPU、内存等。
    nnn # terminal file manager

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



    # 与Nix相关的工具，提供更详细的日志输出。
    nix-output-monitor

    glow # markdown previewer in terminal

    btop  # 系统和网络监控工具
    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

  ];

  # 启用 starship，这是一个漂亮的 shell 提示符
  programs.starship = {
    enable = true;
    # 自定义配置
    settings = {
      add_newline = false;
      aws.disabled = true;  # 使用AWS不显示任何AWS相关的信息
      gcloud.disabled = true;  # 使用Google Cloud Platform不显示任何AWS相关的信息
      line_break.disabled = true; # 表示不在每个提示符之间添加额外的空行
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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # TODO 在这里添加你的自定义 zshrc 内容
    # zshrcExtra = ''
    #   export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    # '';

    # 如果您想设置别名，可以在这里添加
    shellAliases = {
      # 这里添加您的别名
      # 例如：
      # l = "ls -lah"
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