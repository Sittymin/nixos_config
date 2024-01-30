{ config, pkgs, anyrun, ... }:

{

  imports = [
    anyrun.homeManagerModules.default
    ./fcitx5
  ];

  # 注意修改这里的用户名与用户目录
  home.username = "Sittymin";
  home.homeDirectory = "/home/Sittymin";

  # 直接将当前文件夹的配置文件，链接到 Home 目录下的指定位置
  home.file = {
    ".config/hypr/hyprland.conf".source = ./hyprland/hyprland.conf;
    "sing-box/config.json".source = ./singbox/config.json;
    ".config/waybar/config".source = ./waybar/config.json;
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
    mpv

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # 替代grep
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
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

    steam
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
        # add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };

    anyrun = {
      enable = true;
      config = {
        plugins = with anyrun.packages.${pkgs.system}; [
          applications
	];
	width.fraction = 0.3;
        y.absolute = 15;
	hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = false;
        closeOnClick = true;
        showResultsImmediately = false;
        maxEntries = null;
      };
      extraCss = ''
      	@define-color bg-col  rgba(30, 30, 46, 0.7);
      	@define-color bg-col-light rgba(150, 220, 235, 0.7);
      	@define-color border-col rgba(30, 30, 46, 0.7);
      	@define-color selected-col rgba(150, 205, 251, 0.7);
      	@define-color fg-col #D9E0EE;
      	@define-color fg-col2 #F28FAD;

      	* {
      	  transition: 200ms ease;
      	  font-family: "JetBrainsMono Nerd Font";
      	  font-size: 1.3rem;
      	}

      	#window {
      	  background: transparent;
      	}

      	#plugin,
      	#main {
      	  border: 3px solid @border-col;
      	  color: @fg-col;
      	  background-color: @bg-col;
     	}
      	/* anyrun's input window - Text */
      	#entry {
      	  color: @fg-col;
      	  background-color: @bg-col;
     	}

      	/* anyrun's ouput matches entries - Base */
      	#match {
      	  color: @fg-col;
      	  background: @bg-col;
      	}

      	/* anyrun's selected entry - Red */
      	#match:selected {
      	  color: @fg-col2;
      	  background: @selected-col;
      	}

      	#match {
      	  padding: 3px;
      	  border-radius: 16px;
      	}

      	#entry, #plugin:hover {
      	  border-radius: 16px;
      	}

      	box#main {
	  background: rgba(30, 30, 46, 0.7);
          border: 1px solid @border-col;
          border-radius: 15px;
          padding: 5px;
        }
      '';
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
