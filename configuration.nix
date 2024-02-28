{ inputs, config, lib, pkgs, AtaraxiaSjel-NUR, ... }:


{

  imports = [
    ./hardware-configuration.nix
  ];
  boot = {
    # 对于Arc显卡的特殊设置
    initrd.kernelModules = [ "i915" ];
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.configurationLimit = 10; # 引导最多为10个配置文件
      efi.canTouchEfiVariables = true; # 允许GRUB修改EFI变量
      systemd-boot.enable = true; # 启用systemd-boot引导
    };
  };
  # Btrfs自动清理
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "Sittymin" ];
      auto-optimise-store = true; # 自动优化存储
    };
    #每周进行垃圾回收
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

  system.stateVersion = "23.11";

  # 设置系统语言为中文
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-rime
      ];
    };
  };

  # 设置时区为上海
  time.timeZone = "Asia/Shanghai";

  # 设置网络连接
  networking = {
    hostName = "nixos"; # 你可以改成你喜欢的主机名
    networkmanager.enable = true; # 启用NetworkManager来管理网络连接
  };

  # 设置用户账户
  users = {
    # 禁用多用户
    mutableUsers = false;
    users.Sittymin = {
      isNormalUser = true; # 这是一个普通用户，不是管理员
      extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
      home = "/home/Sittymin"; # 这个用户的家目录
      shell = pkgs.nushell; # 这个用户使用nushell作为默认shell
      # 使用mkpasswd -m yescrypt生成的密码
      hashedPassword = "$y$j9T$b0txaUn/Di7FBas5KhsG7/$LLW6.boQATgduZBQCRgqeObBI/Whf2.7Smd3g5g2lf9";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5zdW/9XICvpMixsfbg5IvYyDjfRC1eAJ1Yc1jdOLnz wu2890108976@gmail.com"
      ];
    };
  };


  # 设置系统服务
  services = {
    xserver = {
      enable = true; # 启用X Window System服务
      displayManager.gdm.enable = true;
      videoDrivers = [ "modesetting" ];
    };
    openssh = {
      enable = true; # 启用OpenSSH服务
      settings = {
        X11Forwarding = true; # 允许X11转发
        PermitRootLogin = "no"; # 禁止root用户通过SSH登录
        PasswordAuthentication = false; # 禁止使用密码登录
      };
      openFirewall = true; # 在防火墙中打开SSH端口
    };
    # 启用沙盒应用程序
    flatpak = {
      enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # 可能对于蓝牙连接有作用
      # # Bluetooth support, selective.
      # media-session.config.bluez-monitor.rules = [
      #   {
      #     # Matches all cards
      #     matches = [{ "device.name" = "~bluez_card.*"; }];
      #     actions = {
      #       "update-props" = {
      #         "bluez5.auto-connect" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
      #       };
      #     };
      #   }
      #   {
      #     matches = [
      #       # Matches all sources
      #       { "node.name" = "~bluez_input.*"; }
      #       # Matches all outputs
      #       { "node.name" = "~bluez_output.*"; }
      #     ];
      #     actions = {
      #       "node.pause-on-idle" = false;
      #     };
      #   }
      # ];
    };
    #  蓝牙配对的一个GUI
    blueman.enable = true;
  };



  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
      ];
    };
  };
  # 允许非自由软件
  nixpkgs.config.allowUnfree = true;

  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # 为了让pipewire正xdg.portal常运行的一些东西
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;


  # 设置默认的软件包
  environment.systemPackages = with pkgs; [
    #  git
    curl
    wget

    mesa

    wireplumber

    # 音频兼容层(当前对于我的世界有用)
    alsa-oss

  ];

  # waydroid
  virtualisation.waydroid.enable = true;
  # 文件系统的设置大部分为flatpak解决字体问题
  # system.fsPackages = [ pkgs.bindfs ];
  fileSystems =
    # let
    #   mkRoSymBind = path: {
    #     device = path;
    #     fsType = "fuse.bindfs";
    #     options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    #   };
    #   aggregatedIcons = pkgs.buildEnv {
    #     name = "system-icons";
    #     paths = with pkgs; [
    #       #libsForQt5.breeze-qt5  # for plasma
    #       gnome.gnome-themes-extra
    #     ];
    #     pathsToLink = [ "/share/icons" ];
    #   };
    #   aggregatedFonts = pkgs.buildEnv {
    #     name = "system-fonts";
    #     paths = config.fonts.packages;
    #     pathsToLink = [ "/share/fonts" ];
    #   };
    # in
    {
      # 这个为挂在磁盘与上下部分独立
      "/mnt/CT1000MX500SSD1" = {
        device = "/dev/sda";
        fsType = "btrfs";
        options = [ "defaults" "noatime" "nodiratime" "user=Sittymin" ];
      };
      # 解决Flatpak无法访问系统字体和图标的临时办法

      # "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
      # "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
    };
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Monaspace" ]; })
      #(noto-fonts.override { variants = [ "NotoSans" ]; })
      # maple-mono-otf
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      # Steam的字体
      wqy_zenhei
    ];
    fontconfig = {
      enable = true;
    };

    # defaultFonts 会让Steam找不到字体
    enableDefaultPackages = false;
  };
}
