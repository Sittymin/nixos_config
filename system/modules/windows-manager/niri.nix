{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs = {
    overlays = [
      inputs.niri.overlays.niri
    ];
  };
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  # 是 niri flake 中的
  # https://github.com/sodiboo/niri-flake/blob/main/flake.nix#L271
  # environment.systemPackages = with pkgs; [ xwayland-satellite-unstable ];
}
