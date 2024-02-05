{ pkgs, ... }: {
  programs.nushell = {
    enable = true;
    # 需要添加的路径在append中,而且多个添加不可以直接换行要使用\n（可能可以直接在append中添加多个）
    extraEnv = "$env.PATH = ($env.PATH | split row (char esep) | append '/home/Sittymin/.bun/bin')";
    extraConfig = ''load-env {
      "BUN_INSTALL": "/home/Sittymin/.bun",
      "GDK_BACKEND": "wayland,x11",
      "QT_QPA_PLATFORM": "wayland;xcb",
      "SDL_VIDEODRIVER": "wayland",
      "CLUTTER_BACKEND": "wayland"
    }'';
  };

}
