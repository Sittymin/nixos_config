{
  ...
}:
{
  # 不仅有系统级, 还有用户级的
  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}
