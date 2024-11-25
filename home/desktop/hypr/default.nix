{
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    settings = {
      source = "/etc/nixos/home/desktop/hypr/hyprland.conf";
    };
  };
  # home = {
  #   packages = with pkgs; [
  #     hyprpaper # 一个壁纸软件
  #   ];
  #   file = {
  #     ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  #   };
  # };
}
