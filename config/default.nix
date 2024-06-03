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
      # https://nixos.wiki/wiki/Wayland
      NIXOS_OZONE_WL = "1";
      # nh 的 flake 的查找路径
      FLAKE = "$HOME/nixos_config";
      # BUN 默认不添加安装的Path
      BUN_INSTALL = "$HOME/.bun";
    };
    # 用户帐户的可允许登录 shell 列表。/bin/sh会自动添加
    shells = [ pkgs.nushell ];
    systemPackages = with pkgs; [
      #  git
      curl
      wget

      # mesa
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
      # 运行X11
      # 也许用Hyprland比较好
      # 除非xwayland-satellite搞好了
      gamescope
      myRepo.xwayland-satellite
      # 编译器
      gcc
    ];
  };

  xdg.mime = {
    enable = true;
    ## 默认应用 参考: https://specifications.freedesktop.org/mime-apps-spec/mime-apps-spec-latest.html
    # desktop 文件也许可以通过以下路径找到
    # ~/.local/state/nix/profiles/home-manager/home-path/share/applications
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
    };
  };
}
