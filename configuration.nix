{ pkgs
, inputs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];
  boot = {
    # NOTE:对于Arc显卡的特殊设置
    initrd.kernelModules = [ "i915" ];
    # initrd.kernelModules = [ "xe" ];
    kernelModules = [ "xe" "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    # NOTE:设置内核参数
    # NOTE:启用IOMMU
    kernelParams = [ "intel_iommu=on" ];
    loader = {
      # NOTE:引导最多为10个配置文件
      systemd-boot.configurationLimit = 10;
      # NOTE:允许GRUB修改EFI变量
      efi.canTouchEfiVariables = true;
      # NOTE:启用systemd-boot引导
      systemd-boot.enable = true;
    };
    # NOTE: 启用嵌套虚拟化
    # NOTE: 不模拟无效的客户机状态
    # NOTE: 忽略模型特定的寄存器（MSRs）
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';
  };
  # NOTE: Btrfs自动清理
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "Sittymin" ];
      # NOTE: 在每次构建过程中对存储进行优化
      # PERF: 由nh的垃圾回收方式替代
      # auto-optimise-store = true;
    };
    # NOTE:每周进行垃圾回收
    # PERF: 由nh的垃圾回收方式替代
    # WARN: 可能无用
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 1w";
    # };
    # NOTE:在使用了__noChroot = true的包中禁用沙盒
    # HACK:oneapi目前需要
    extraOptions = ''sandbox = relaxed'';
  };

  system.stateVersion = "23.11";

  # NOTE:设置系统语言为中文
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        fcitx5-rime
      ];
    };
  };

  # NOTE:设置时区为上海
  time.timeZone = "Asia/Shanghai";

  # NOTE:设置网络连接
  networking = {
    hostName = "nixos"; # NOTE:主机名
    networkmanager.enable = true; # NOTE:启用NetworkManager来管理网络连接
  };

  # NOTE:设置用户账户
  users = {
    # NOTE:禁用多用户
    mutableUsers = false;
    users.Sittymin = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "video" "audio" "libvirtd" "docker" ];
      # NOTE:家目录
      home = "/home/Sittymin";
      # NOTE:默认shell
      shell = pkgs.nushell;
      # NOTE:使用mkpasswd -m yescrypt生成的密码
      hashedPassword = "$y$j9T$b0txaUn/Di7FBas5KhsG7/$LLW6.boQATgduZBQCRgqeObBI/Whf2.7Smd3g5g2lf9";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5zdW/9XICvpMixsfbg5IvYyDjfRC1eAJ1Yc1jdOLnz wu2890108976@gmail.com"
      ];
    };
  };


  # NOTE:设置系统服务
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      videoDrivers = [ "modesetting" ];
    };
    openssh = {
      enable = true;
      settings = {
        # NOTE:允许X11转发
        X11Forwarding = true;
        PermitRootLogin = "no";
        # NOTE:禁止使用密码登录
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };
    flatpak = {
      enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    # NOTE:蓝牙配对的一个GUI
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
        # ffmpeg硬件编解码仍然需要上面的
        # 上面的应该被onevpl代替
        # ffmpeg -init_hw_device qsv=hw -filter_hw_device hw -v verbose -i input.mp4 -c:v av1_qsv output.mkv
        onevpl-intel-gpu
        intel-compute-runtime
        # NOTE:用于X11与Wayland硬件加速互通 
        libvdpau-va-gl
      ];
    };
  };
  # NOTE:允许非自由软件
  nixpkgs.config.allowUnfree = true;
  programs = {
    # NOTE:Steam参考于
    # https://github.com/fufexan/dotfiles/blob/main/system/programs/steam.nix
    steam = {
      enable = true;

      # fix gamescope inside steam
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            keyutils
            libkrb5
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            lxgw-neoxihei
          ];
      };
    };
    gamescope.enable = true;

    hyprland = {
      enable = true;
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    # NOTE:KVM
    virt-manager.enable = true;

    # PERF: nh NixOS 模块提供了一种垃圾回收方式，可替代默认的垃圾回收方式
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
    };
  };
  xdg.portal = {
    enable = true;
    # https://github.com/NixOS/nixpkgs/issues/160923
    # xdgOpenUsePortal = true;
    # 设置后端关联
    config = {
      common.default = [ "gtk" ];
      # hyprland.default = [ "hyprland" "gtk" ];
    };

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # 为了让pipewire正常运行的一些东西
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;


  # 设置默认的软件包
  environment.systemPackages = with pkgs; [
    #  git
    curl
    wget

    mesa
    wireplumber
    # VA-API（视频加速API）的实现
    libva
    # VA-API的一组实用工具和示例
    libva-utils
    # Intel 视频处理库
    libvpl
    # Intel OneAPI 数学核心库
    mkl
    # Intel OneAPI深度神经网络库
    oneDNN
    # 音频兼容层(当前对于我的世界有用)
    alsa-oss
    # 显示文件类型的程序
    file
    # Other Linux
    distrobox
  ];

  # NOTE:虚拟环境 
  virtualisation = {
    waydroid.enable = true;
    docker.enable = true;
    # KVM
    libvirtd.enable = true;
  };
  fileSystems = {
    "/mnt/CT1000MX500SSD1" = {
      device = "/dev/sda";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "nodiratime" "user=Sittymin" ];
    };
  };
  fonts = {
    packages = with pkgs; [
      # Icon fonts
      material-symbols
      # Nerd Fonts
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      # (nerdfonts.override { fonts = [ "Monaspace" ]; })
      # mono fonts
      # kitty用的是Var版本
      monaspace
      noto-fonts
      lxgw-neoxihei
      lxgw-wenkai
      noto-fonts-color-emoji
    ];
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "Monaspace Neon" "Noto Color Emoji" ];
        sansSerif = [ "LXGW Neo XiHei" "Noto Color Emoji" ];
        serif = [ "LXGW WenKai" "Noto Color Emoji" ];
      };
    };
    # 触发问题比解决问题多
    # https://github.com/fufexan/dotfiles/blob/0cf7097bb093f3f60a165981a1996d9cf6e96f9f/system/programs/fonts.nix#L21
    enableDefaultPackages = false;
  };
}
