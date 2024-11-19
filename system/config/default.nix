{ pkgs
, ...
}: {
  imports = [
    ./bluetooth.nix
    ./fonts.nix
    ./locale.nix
    ./networking.nix
    ./audio.nix
    ./user.nix
  ];

  environment = {
    # 全局环境中使用的一组环境变量
    variables = {
      EDITOR = "hx";
      # 设置 Rustup 镜像(字节跳动)
      RUSTUP_DIST_SERVER = "https://rsproxy.cn";
      RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
    };
    # 用户登录时初始化的环境变量
    sessionVariables = {
      # 输入法的环境变量 https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
      # 需要QT软件构建使用了 fcitx 模块
      QT_IM_MODULE = "fcitx";
      QT_IM_MODULES = "wayland;fcitx;ibus";
      XMODIFIERS = "@im=fcitx";
      # https://nixos.wiki/wiki/Wayland
      # 实际上不能输入的依旧不能输入, 但是可以让实验Wayland启用
      NIXOS_OZONE_WL = "1";
      # GTK 优先使用 Wayland
      GDK_BACKEND = "wayland,x11,*";
      # QT 优先使用 Wayland
      QT_QPA_PLATFORM = "wayland;xcb";
      # SDL 游戏优先使用 Wayland
      # Steam 在Xwayland环境下也会尝试使用，导致无法启动
      # SDL_VIDEODRIVER = "wayland";
      # Clutter 好像是一个图形界面的库
      CLUTTER_BACKEND = "wayland";
      # nh 的 flake 的查找路径
      FLAKE = "$HOME/nixos_config";
      # BUN 默认不添加安装的Path
      BUN_INSTALL = "$HOME/.bun";
      # 暗色偏好
      GTK_THEME = "Adwaita:dark";
      # 启用 Intel 显卡视频解码
      # https://github.com/mpv-player/mpv/discussions/13909
      ANV_VIDEO_DECODE = 1;
    };
    # 用户帐户的可允许登录 shell 列表。/bin/sh会自动添加
    shells = [ pkgs.nushell ];
    systemPackages = (with pkgs; [
      sing-box
      # git
      curl
      wget
      wireplumber
      btop # 系统和网络监控工具
      intel-gpu-tools # 可以用intel_gpu_top显示Arc显卡占用情况
      # 解压缩软件
      p7zip # 7z
      zstd
      # BLAKE3 加密哈希函数
      b3sum

      android-tools
      # 显示文件类型的程序
      file
      # 可以使用 eglinfo 查看 mesa 版本
      mesa-demos
      # Qt 图片加载库（JXL）
      libsForQt5.kimageformats
      # GTK 图片加载库
      gdk-pixbuf

      # 音频兼容层(当前对于我的世界有用)
      alsa-oss
      # TPM
      swtpm
      # 向路由器请求UPnP
      miniupnpc
      # 复制到系统剪贴板
      wl-clipboard
    ]);
    # ]) ++ (
    # with inputs.daeuniverse.packages.x86_64-linux; [
    #   dae
    # ]
    # );
  };

  xdg = {
    mime = {
      enable = true;
      # 系统级默认程序
      defaultApplications = { };
    };
  };
}
