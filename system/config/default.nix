{ pkgs
, inputs
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
      # 实际上不能输入的依旧不能输入, 但是可以让实验Wayland启用
      NIXOS_OZONE_WL = "1";
      # GTK 优先使用 Wayland
      GDK_BACKEND = "wayland,x11,*";
      # QT 优先使用 Wayland
      QT_QPA_PLATFORM = "wayland;xcb";
      # SDL 游戏优先使用 Wayland
      SDL_VIDEODRIVER = "wayland";
      # Clutter 好像是一个图形界面的库
      CLUTTER_BACKEND = "wayland";
      # nh 的 flake 的查找路径
      FLAKE = "$HOME/nixos_config";
      # BUN 默认不添加安装的Path
      BUN_INSTALL = "$HOME/.bun";
      # 暗色偏好
      GTK_THEME = "Adwaita:dark";
    };
    # 用户帐户的可允许登录 shell 列表。/bin/sh会自动添加
    shells = [ pkgs.nushell ];
    systemPackages = (with pkgs; [
      #  git
      curl
      wget
      wireplumber

      mesa_git
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
      # vulkan
      vulkan-loader
      vulkan-tools
      # intel 给 VAAPI 的媒体驱动
      intel-media-driver
      # 音频兼容层(当前对于我的世界有用)
      alsa-oss
      # 显示文件类型的程序
      file
      # Other Linux
      distrobox
      # 编译器
      gcc
      # TPM
      swtpm
      # 可以使用 eglinfo 查看 mesa 版本
      mesa-demos

    ]);
    # ]) ++ (
    # with inputs.daeuniverse.packages.x86_64-linux; [
    #   dae
    # ]
    # );
  };

  xdg.mime = {
    enable = true;
    ## 默认应用 参考: https://specifications.freedesktop.org/mime-apps-spec/mime-apps-spec-latest.html
    # desktop 文件也许可以通过以下路径找到
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
      "application/zip" = "org.gnome.FileRoller.desktop";
      # 文件夹打开方式
      "inode/directory" = "org.gnome.Nautilus.desktop";
    };
  };
}
