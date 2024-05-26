{ pkgs, ... }: {
  programs.nushell = {
    enable = true;
    # 需要添加的路径在prepend中,而且多个添加中间用冒号隔开(:),添加另外命令用\n分隔
    extraEnv = "$env.PATH = ($env.PATH | prepend '/home/Sittymin/.bun/bin')";
    extraConfig = ''load-env {
      # BUN 默认不添加安装的Path
      "BUN_INSTALL": "/home/Sittymin/.bun",
      # 优先使用 Wayland (可能有用)
      "GDK_BACKEND": "wayland,x11",
      "QT_QPA_PLATFORM": "wayland;xcb",
      "SDL_VIDEODRIVER": "wayland",
      "CLUTTER_BACKEND": "wayland",
      # nh 的 flake 的查找路径
      "FLAKE": "/home/Sittymin/nixos_config"
      # 设置 Rustup 镜像(字节跳动)
      "RUSTUP_DIST_SERVER": "https://rsproxy.cn"
      "RUSTUP_UPDATE_ROOT": "https://rsproxy.cn/rustup"
      }'';
  };
  # PERF: FLAKE为nh配置 FLAKE 环境变量
}
