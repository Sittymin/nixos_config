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
      # 实际上不能输入的依旧不能输入, 但是可以让实验Wayland启用
      # NIXOS_OZONE_WL = "1";
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
      # 也许这个加载没啥用
      vulkan-tools
      # 音频兼容层(当前对于我的世界有用)
      alsa-oss
      # 显示文件类型的程序
      file
      # Other Linux
      distrobox
      # 编译器
      gcc

      localsend
    ];
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
