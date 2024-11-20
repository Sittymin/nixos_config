{ pkgs, ... }: {
  xdg.configFile."mako/config" = {
    source = ./config;
  };
  home = {
    # file = {
    #   ".config/mako/config".source = ./config;
    # };
    packages = with pkgs; [
      mako
    ];
  };
}
