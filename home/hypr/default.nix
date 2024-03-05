{ pkgs
, ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    settings = {
      source = "/etc/nixos/home/hypr/hyprland.conf";
    };
  };
}
