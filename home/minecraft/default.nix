{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    (prismlauncher.override
      {
        jdks = [ temurin-bin temurin-bin-17 ];
        # Wayland 原生运行 Minecraft
        # 设置 -> Minecraft -> 微调 -> 使用系统 GLFW
        withWaylandGLFW = true;
      }
    )
  ];
}
