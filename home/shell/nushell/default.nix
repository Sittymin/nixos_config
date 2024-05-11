{ pkgs, ... }: {
  programs.nushell = {
    enable = true;
    # 需要添加的路径在prepend中,而且多个添加中间用冒号隔开(:),添加另外命令用\n分隔
    extraEnv = "$env.PATH = ($env.PATH | prepend '/home/Sittymin/.bun/bin')";
    extraConfig = ''load-env {
      "BUN_INSTALL": "/home/Sittymin/.bun",
      "GDK_BACKEND": "wayland,x11",
      "QT_QPA_PLATFORM": "wayland;xcb",
      "SDL_VIDEODRIVER": "wayland",
      "CLUTTER_BACKEND": "wayland",
      "GDK_SCALE": "2",
      "GTK_THEME": "Adwaita:dark",
      "FLAKE": "/home/Sittymin/nixos_config"
      }'';
  };
  # PERF: FLAKE为nh配置 FLAKE 环境变量
}
