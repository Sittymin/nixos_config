{ pkgs, ... }: {
  home = {
    file = {
      ".config/mako/config".source = ./config;
    };
    packages = with pkgs; [
      mako
    ];
  };
}
